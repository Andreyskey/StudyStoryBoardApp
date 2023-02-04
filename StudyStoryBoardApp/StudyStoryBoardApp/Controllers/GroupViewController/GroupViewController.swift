//
//  GroupViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 14.10.2022.
//

import UIKit
import Alamofire
import RealmSwift

class GroupViewController: UIViewController {
    
    var groups: Results<GroupItem>?
    let groupViewControllerIdentifier = "groupViewControllerIdentifier"
    let refresh = UIRefreshControl()
    let realm = try! Realm()
    var token: NotificationToken?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noHaveGroupText: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        refrashGroups()
        tableView.delegate = self
        tableView.dataSource = self
        refresh.addTarget(self, action: #selector(refrashGroups), for: .valueChanged)
        tableView.addSubview(refresh)
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: groupViewControllerIdentifier)
        refresh.beginRefreshing()
        
        groups = realm.objects(GroupItem.self)
        
        if groups != nil {
            token = groups!.observe { (changes: RealmCollectionChange) in
                switch changes {
                case .initial:
                    self.tableView.reloadData()
                case .update(_, _, _, _):
                    self.tableView.reloadData()
                case .error(let error):
                    fatalError("\(error)")
                }
            }
        }
    }
    
    @objc func refrashGroups() {
        ServiseAPI().getRequestGroups {
            self.refresh.endRefreshing()
        }
    }
    
    @IBAction func searchGroup(_ sender: Any) {
        performSegue(withIdentifier: "searchGroup", sender: nil)
    }
    
    @IBAction func unwindToGroup(_ unwindSegue: UIStoryboardSegue) {
    }
}


extension GroupViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let groups = groups else { return 0 }
        if groups.isEmpty { return 0 }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: groupViewControllerIdentifier, for: indexPath) as? CustomTableViewCell,
              let groups = groups
        else { return UITableViewCell() }

        cell.configurationCell(object: Array(groups)[indexPath.section])

        return cell
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        guard let groups = groups else { return 0 }
        return groups.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { action, view, complete in
            guard let groups = self.groups else { return }
            ServiseAPI().leaveGroup(idGroup: groups[indexPath.section].id){
                try! self.realm.write {
                    if let group = self.realm.object(ofType: GroupItem.self, forPrimaryKey: groups[indexPath.section].id) {
                        self.realm.delete(group)
                    }
                }
            }
            
            if groups.count == 0 {
                self.noHaveGroupText.isHidden = false
            } else {
                self.noHaveGroupText.isHidden = true
            }
            complete(true)
        }
        
        deleteAction.image = UIImage(named: "deleteSection")
        deleteAction.backgroundColor = UIColor(cgColor: CGColor(red: 1, green: 1, blue: 1, alpha: 0))

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }


}

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
    
    var groups = [GroupItem]()
    let groupViewControllerIdentifier = "groupViewControllerIdentifier"
    let refresh = UIRefreshControl()
    let realm = try! Realm()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noHaveGroupText: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        refresh.addTarget(self, action: #selector(refrashGroups), for: .valueChanged)
        tableView.addSubview(refresh)
        
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: groupViewControllerIdentifier)
        
        refresh.beginRefreshing()
    }

    override func viewWillAppear(_ animated: Bool) {
        refrashGroups()
    }
    
    @objc func refrashGroups() {
        ServiseAPI().getRequestGroups {
            if let groups = self.realm.objects(Groups.self).first?.items {
                self.groups = Array(groups)
                self.tableView.reloadData()
                self.refresh.endRefreshing()
            }
        }
    }
    
    @IBAction func searchGroup(_ sender: Any) {
        performSegue(withIdentifier: "searchGroup", sender: nil)
    }

    @IBAction func unwindToGroup(_ unwindSegue: UIStoryboardSegue) {
        refrashGroups()
    }
}


extension GroupViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if groups.count == 0 { return 0 }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: groupViewControllerIdentifier, for: indexPath) as? CustomTableViewCell
        else { return UITableViewCell() }

        cell.configurationCell(object: groups[indexPath.section])

        return cell
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { action, view, complete in
            ServiseAPI().leaveGroup(idGroup: self.groups[indexPath.section].id) {
                self.groups.remove(at: indexPath.section)
                tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .fade)
                self.refrashGroups()
            }
            
            if self.groups.count == 0 {
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

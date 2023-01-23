//
//  GroupViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 14.10.2022.
//

import UIKit
import Alamofire

class GroupViewController: UIViewController {
    
    var groups = [GroupItem]()
    let groupViewControllerIdentifier = "groupViewControllerIdentifier"
    let paramsGroup: Parameters = [
        "access_token" : Session.share.token,
        "user_id" : Session.share.userId,
        "extended" : "1",
        "fields" : "members_count, activity",
        "v" : "5.131"
    ]

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var noHaveGroupText: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: groupViewControllerIdentifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        ServiseAPI().getRequestGroups(method: .groupsGet, parammeters: paramsGroup) { array in
            guard let groupsArr = array else { return }
            self.groups = groupsArr
            self.tableView.reloadData()
        }
    }
    
    @IBAction func searchGroup(_ sender: Any) {
        performSegue(withIdentifier: "searchGroup", sender: nil)
    }

    @IBAction func unwindToGroup(_ unwindSegue: UIStoryboardSegue) {
//        guard unwindSegue.identifier == "addGroup",
//              let segue = unwindSegue.source as? SearchViewController,
//              let indexPaths = segue.tableView.indexPathsForSelectedRows
//        else { return }
//
//        for i in indexPaths {
//            let group = groups[i.section]
//            if !myGroups.contains(where: {$0 == group}) {
//                myGroups.append(group)
//            }
//        }
//        self.noHaveGroupText.isHidden = true
//        tableView.reloadData()
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

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        groups.remove(at: indexPath.section)
        print(groups.count)
        tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .fade)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { action, view, complete in
            self.groups.remove(at: indexPath.section)
            tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .fade)
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

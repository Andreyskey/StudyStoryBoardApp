//
//  GroupViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 14.10.2022.
//

import UIKit

class GroupViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var noHaveGroupText: UILabel!
    
    let groupViewControllerIdentifier = "groupViewControllerIdentifier"
    
    var myGroups = [
        Group(name: "Amediateka", image: "Amediateka", infoGroup: "Онлайн-кинотеатр, 450К подписчиков")
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: groupViewControllerIdentifier)
    }

    @IBAction func searchGroup(_ sender: Any) {
        performSegue(withIdentifier: "searchGroup", sender: nil)
    }
    
    @IBAction func unwindToGroup(_ unwindSegue: UIStoryboardSegue) {
        guard unwindSegue.identifier == "addGroup",
              let segue = unwindSegue.source as? SearchViewController,
              let indexPaths = segue.tableView.indexPathsForSelectedRows
        else { return }
        
        for i in indexPaths {
            let group = groups[i.section]
            if !myGroups.contains(where: {$0 == group}) {
                myGroups.append(group)
            }
        }
        self.noHaveGroupText.isHidden = true
        tableView.reloadData()
    }
    
    deinit {
        print("Delete GroupController")
    }
}


extension GroupViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if myGroups.count == 0 {
            return 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: groupViewControllerIdentifier, for: indexPath) as? CustomTableViewCell
        else { return UITableViewCell() }
        
        cell.configurationCell(friend: nil, group: myGroups[indexPath.section])
        
        return cell
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return myGroups.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        myGroups.remove(at: indexPath.section)
        print(myGroups.count)
        tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .fade)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { action, view, complete in
            self.myGroups.remove(at: indexPath.section)
            tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .fade)
            if self.myGroups.count == 0 {
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

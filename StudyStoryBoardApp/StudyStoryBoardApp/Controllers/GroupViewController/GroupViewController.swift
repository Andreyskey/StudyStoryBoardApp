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
    
    let groupViewControllerIdentifier = "groupViewControllerIdentifier"
    
    var groups = [
        "Apple"
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
              let indexPath = segue.tableView.indexPathForSelectedRow?.row
        else { return }
        
        let group = segue.allGroups[indexPath]
        
        if !groups.contains(group) {
            groups.append(group)
            tableView.reloadData()
        }
    }
}


extension GroupViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: groupViewControllerIdentifier, for: indexPath) as? CustomTableViewCell
        else { return UITableViewCell() }
        
        cell.configurationCell(photo: UIImage(named: groups[indexPath.row]), fullName: groups[indexPath.row])
        
        return cell
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        groups.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
}

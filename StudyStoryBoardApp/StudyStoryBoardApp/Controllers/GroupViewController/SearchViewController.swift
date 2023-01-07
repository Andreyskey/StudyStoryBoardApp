//
//  SearchViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 14.10.2022.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var button: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    let searchViewControllerIndentifier = "searchViewControllerIndentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.isHidden = true
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: searchViewControllerIndentifier)
    }
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: searchViewControllerIndentifier, for: indexPath) as? CustomTableViewCell
        else { return UITableViewCell() }
        
        cell.configurationCell(friend: nil, group: groups[indexPath.section])
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundConfiguration?.backgroundColor = .white
        cell?.backgroundConfiguration?.strokeColor = .systemRed
        button.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        var cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundConfiguration?.backgroundColor = .white
        cell?.backgroundConfiguration?.strokeColor = UIColor(red: 0.90, green: 0.95, blue: 0.96, alpha: 1.00)
        return indexPath
    }
    
    
}

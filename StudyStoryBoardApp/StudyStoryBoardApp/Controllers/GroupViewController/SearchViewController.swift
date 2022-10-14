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
    let allGroups = [
        "Apple",
        "Microsoft",
        "The New York Times",
        "Developer iOS",
        "Amediateka",
        "GitHub",
        "Spotify",
        "Yandex",
        "Netflix"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.isHidden = true
        
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: searchViewControllerIndentifier)
        
        button.isHidden = true
    }
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGroups.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: searchViewControllerIndentifier, for: indexPath) as? CustomTableViewCell
        else { return UITableViewCell() }
        
        cell.configurationCell(photo: UIImage(named: allGroups[indexPath.row]), fullName: allGroups[indexPath.row])
        
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        button.isHidden = false
    }
    
}

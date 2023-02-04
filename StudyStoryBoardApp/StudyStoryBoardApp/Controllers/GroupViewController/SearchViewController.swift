//
//  SearchViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 14.10.2022.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController {
    
    let searchViewControllerIndentifier = "searchViewControllerIndentifier"
    var groups = [GroupItem]()

    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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

        cell.configurationCell(object: groups[indexPath.section])

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionJoin = UIAlertAction(title: "Вступить", style: .default) { action in
            ServiseAPI().joinGrouo(idGroup: self.groups[indexPath.section].id) { result in
                if result {
                    print("joined group")
                    self.performSegue(withIdentifier: "addedGroup", sender: nil)
                } else {
                    let alert = UIAlertController(title: "Вы уже состоите в группе",
                                                 message: nil,
                                                 preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ок", style: .cancel))
                    self.present(alert, animated: true)
                }
            }
        }
        let actionCancel = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(actionJoin)
        alert.addAction(actionCancel)
        self.present(alert, animated: true)
    }

}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            
            ServiseAPI().searchGroups(searchText: searchText) { array in
                guard let findGroups = array else { return }
                self.groups = Array(findGroups)
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}

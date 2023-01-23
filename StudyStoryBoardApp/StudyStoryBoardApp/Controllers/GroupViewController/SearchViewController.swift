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
    var groups = [Group]()

    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.stopAnimating()
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

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath)
//        cell?.backgroundConfiguration?.backgroundColor = .white
//        cell?.backgroundConfiguration?.strokeColor = .systemRed
//
//    }
//
//    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
//        let cell = tableView.cellForRow(at: indexPath)
//        cell?.backgroundConfiguration?.backgroundColor = .white
//        cell?.backgroundConfiguration?.strokeColor = UIColor(red: 0.90, green: 0.95, blue: 0.96, alpha: 1.00)
//        return indexPath
//    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            loadingIndicator.startAnimating()
            let params: Parameters = [
                "access_token" : Session.share.token,
                "user_id" : Session.share.userId,
                "q" : searchText,
                "count" : "50",
                "v" : "5.131"
            ]
            
            ServiseAPI().getRequestGroups(method: "groups.search", parammeters: params) { array in
                guard let findGroups = array else { return }
                self.groups = findGroups
                self.tableView.reloadData()
                self.loadingIndicator.stopAnimating()
            }
        }
    }
}

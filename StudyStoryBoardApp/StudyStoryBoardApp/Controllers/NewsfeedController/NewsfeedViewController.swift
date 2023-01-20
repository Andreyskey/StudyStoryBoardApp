//
//  NewsfeedViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 01.11.2022.
//

import UIKit
import Alamofire

class NewsfeedViewController: UIViewController {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    let nofityLoadingData = Notification.Name("loadingSuccess")
    let loadData = Notification.Name("loadData")
    let newsfeedViewControllerIdentificator = "newsfeedViewControllerIdentificator"
    var wall = [WallItem]()
    var groups = [GroupItem]()
    var profiles = [ProfileItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.alpha = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableViewData), name: nofityLoadingData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadWall), name: loadData, object: nil)
        
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: newsfeedViewControllerIdentificator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(Notification(name: loadData))
    }
    
    @objc func loadWall() {
        let params: Parameters = [
            "access_token" : Session.share.token,
            "extended" : "1",
            "count" : "30",
            "filter" : "all",
            "fields" : "photo_200, online, status",
            "v" : "5.131"
        ]
        
        ServiseAPI().getRequestWall(method: "wall.get", parammeters: params) { wall, friends, groups in
            guard let posts = wall,
                  let friends = friends,
                  let groupsWall = groups
            else { return }
            self.wall = posts
            self.profiles = friends
            self.groups = groupsWall
            self.tableView.reloadData()
        }
    }
    
    @objc func reloadTableViewData() {
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.animate(withDuration: 1.5) {
            self.tableView.alpha = 1
        }
        loadingIndicator.stopAnimating()
    }
}

extension NewsfeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wall.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: newsfeedViewControllerIdentificator, for: indexPath) as? PostTableViewCell
        else { return UITableViewCell() }
        
        var owner: Any?
        
        for i in profiles {
            if i.id == wall[indexPath.row].fromID && wall[indexPath.row].copyHistory == nil {
                owner = i
                break
            }
        }

        for i in groups {
            if i.id == ((wall[indexPath.row].copyHistory?.first?.attachments.first?.photo?.ownerID ?? 0) * (-1)){
                owner = i
                break
            }
        }

        cell.configurate(post: self.wall[indexPath.row], owner: owner)
        
        return cell
    }
}

//
//  NewsfeedViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 01.11.2022.
//

import UIKit
import Alamofire

class NewsfeedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let newsfeedViewControllerIdentificator = "newsfeedViewControllerIdentificator"
    var newsFeed = [Wall]()
    var groups = [Group]()
    var profiles = [Friend]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: newsfeedViewControllerIdentificator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let params: Parameters = [
            "access_token" : Session.share.token,
            "extended" : "1",
            "count" : "30",
            "filter" : "all",
            "v" : "5.131"
        ]
        
        ServiseAPI().getRequestWall(method: "wall.get", parammeters: params) { wall, friends, groups in
            guard let posts = wall,
                  let friends = friends,
                  let groupsWall = groups
            else { return }
            self.newsFeed = posts
            self.profiles = friends
            self.groups = groupsWall
            self.tableView.reloadData()
        }
    }
    

}

extension NewsfeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsFeed.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: newsfeedViewControllerIdentificator, for: indexPath) as? PostTableViewCell
        else { return UITableViewCell() }
        
        var owner: AnyObject?
        
        for i in groups {
            print(i.id)
            print(newsFeed[indexPath.row].ownerId)
            if i.id == (newsFeed[indexPath.row].ownerId * (-1)){
                owner = i
                break
            }
        }
        
        for i in profiles {
            if i.id == newsFeed[indexPath.row].ownerId {
                owner = i
                break
            }
        }
        
        cell.configurate(post: newsFeed[indexPath.row], owner: owner)
        
        return cell
    }
}

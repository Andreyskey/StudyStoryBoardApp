//
//  NewsfeedViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 01.11.2022.
//

import UIKit
import Alamofire
import RealmSwift

class WallViewController: UIViewController {

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
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func loadWall() {
        let params: Parameters = [
            "access_token" : UserDefaults().value(forKey: "token") as! String,
            "extended" : "1",
            "count" : "100",
            "filter" : "all",
            "fields" : "photo_200, online, status",
            "v" : "5.131"
        ]
        
        ServiseAPI().getRequestWall(method: .wallGet, parammeters: params) { walls in
            guard let posts = walls?.items,
                  let friends = walls?.profiles,
                  let groupsWall = walls?.groups
            else { return }
            self.wall = Array(posts)
            self.profiles = Array(friends)
            self.groups = Array(groupsWall)
            self.tableView.reloadData()
        }
    }
    
    @objc func reloadTableViewData() {
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.animate(withDuration: 1.5) {
            self.tableView.alpha = 1
        }
    }
    
    @IBAction func logoutApp(_ sender: Any) {
        UserDefaults().setValue(false, forKey: "isLogin")
        UserDefaults().removeObject(forKey: "token")
        UserDefaults().removeObject(forKey: "userID")
        try! Realm().write{
            try! Realm().deleteAll()
        }
        
    }
    
}

extension WallViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wall.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: newsfeedViewControllerIdentificator, for: indexPath) as? UITableViewCell
        else { return UITableViewCell() }
        
        var owner: AnyObject?
        
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

//        cell.configurate(post: self.wall[indexPath.row], owner: owner)
        
        return cell
    }
}

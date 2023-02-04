//
//  MessageViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 07.01.2023.
//

import UIKit
import Alamofire

class MessageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let refresh = UIRefreshControl()
    
    let identifierMessageViewCOntroller = "identifierMessageViewCOntroller"
    let nofityLoadingData = Notification.Name("loadingSuccess")
    let loadData = Notification.Name("loadData")
    
    var posts = [NewsFeedItem]()
    var groups = [GroupItem]()
    var profiles = [ProfileItem]()
    var nextfrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: identifierMessageViewCOntroller)
        tableView.addSubview(refresh)
        
        refresh.addTarget(self, action: #selector(loadWall), for: .valueChanged)
        refresh.beginRefreshing()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableViewData), name: nofityLoadingData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadWall), name: loadData, object: nil)
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
            "filters" : "post",
            "max_photos" : "1",
            "sourse_ids" : "friends, groups, following",
            "count" : "100",
            "fields" : "photo_200",
            "v" : "5.131"
        ]
        
        ServiseAPI().getRequestNewsfeed(method: .newsfeedGet, parammeters: params) { news, prof, grp, nxtFrm in
            guard let post = news,
                  let profile = prof,
                  let group = grp
            else { return }
            self.posts = post
            self.profiles = profile
            self.groups = group
            self.tableView.reloadData()
            self.refresh.endRefreshing()
        }
    }
    
    @objc func reloadTableViewData() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifierMessageViewCOntroller, for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        
        var owner: AnyObject?
        
        for i in profiles {
            if i.id == posts[indexPath.row].sourseID {
                owner = i
                break
            }
        }

        for i in groups {
            if i.id == ((posts[indexPath.row].sourseID) * (-1)){
                owner = i
                break
            }
        }
        
        cell.alpha = 0
        
        cell.configurate(post: posts[indexPath.row], owner: owner)
        
        UIView.animate(withDuration: 1, delay: 0, options: .allowUserInteraction) {
            cell.alpha = 1
        }

        return cell
        
    }
}

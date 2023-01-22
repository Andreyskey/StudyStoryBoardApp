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
        
        tableView.alpha = 0
        
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: identifierMessageViewCOntroller)
        
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
            "access_token" : Session.share.token,
            "filters" : "post",
            "max_photos" : "1",
            "sourse_ids" : "friends, groups, following",
            "fields" : "photo_200",
            "v" : "5.131"
        ]
        
        ServiseAPI().getRequestNewsfeed(method: .newsfeedGet, parammeters: params) { news, prof, grp, nxtFrm in
            guard let post = news,
                  let profile = prof,
                  let group = grp,
                  let nextFrom = nxtFrm
            else { return }
            self.posts = post
            self.profiles = profile
            self.groups = group
            self.nextfrom = nextFrom
            self.tableView.reloadData()
        }
    }
    
    @objc func reloadTableViewData() {
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.animate(withDuration: 1.5) {
            self.tableView.alpha = 1
        }
//        loadingIndicator.stopAnimating()
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
        
        cell.configurate(post: posts[indexPath.row], owner: owner)

        return cell
    }

}

//
//  MessageViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 07.01.2023.
//

import UIKit
import Alamofire
import RealmSwift

class NewsfeedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let refresh = UIRefreshControl()
    
    // Identificators
    let headerCellIdentifier = "headerCellIdentifier"
    let textCellIdentifier = "textCellIdentifier"
    let imagesPostIdentifier = "imagesPostIdentifier"
    let reactionFooterIdentifier = "reactionFooterIdentifier"

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
        
        tableView.register(UINib(nibName: "HeaderPostCell", bundle: nil), forCellReuseIdentifier: headerCellIdentifier)
        tableView.register(UINib(nibName: "TextPostCell", bundle: nil), forCellReuseIdentifier: textCellIdentifier)
        tableView.register(UINib(nibName: "ImagesPostCell", bundle: nil), forCellReuseIdentifier: imagesPostIdentifier)
        tableView.register(UINib(nibName: "ReactionFooterCell", bundle: nil), forCellReuseIdentifier: reactionFooterIdentifier)
        
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
        DispatchQueue.global().async {
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
    }
    
    @objc func reloadTableViewData() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension NewsfeedViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if posts[section].haveTextAndMedia {
            return 4
        } else {
            return 3
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let postObject = posts[indexPath.section]
        let countCellsInSection = tableView.numberOfRows(inSection: indexPath.section) - 1
        print(countCellsInSection)
        
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: headerCellIdentifier, for: indexPath) as? HeaderPostCell {
                
                if postObject.ownerID < 0 {
                    let owner = groups.filter { item in
                        item.id == (postObject.ownerID * -1)
                    }.first
                    cell.configurate(avatar: owner?.avatar ?? "error", name: owner?.name ?? "error", timePublic: postObject.date)
                } else {
                    let owner = profiles.filter { item in
                        item.id == postObject.ownerID
                    }.first
                    let fullname = "\(owner?.firstName ?? "Err") \(owner?.lastName ?? "Err")"
                    cell.configurate(avatar: owner?.avatar ?? "Eroor", name: fullname, timePublic: postObject.date)
                }
                
                return cell
            }
            
        case countCellsInSection:
            if let cell = tableView.dequeueReusableCell(withIdentifier: reactionFooterIdentifier, for: indexPath) as? ReactionFooterCell {
                cell.setReactions(likes: postObject.likes?.count ?? 0, comments: postObject.comments?.count ?? 0, share: postObject.reposts.count, views: postObject.views?.count ?? 0)
                return cell
            }
            
        default:
            if (postObject.haveTextAndMedia || postObject.text != "") && indexPath.row == 1 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as? TextPostCell {
                    cell.addTextPost(postObject.text)
                    return cell
                }
            } else if postObject.haveTextAndMedia || ((postObject.attachments?.isEmpty) != nil) {
                if let cell = tableView.dequeueReusableCell(withIdentifier: imagesPostIdentifier, for: indexPath) as? ImagesPostCell {
                    cell.addImages(size: postObject.attachments?.first?.photo?.sizes.last)
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
}

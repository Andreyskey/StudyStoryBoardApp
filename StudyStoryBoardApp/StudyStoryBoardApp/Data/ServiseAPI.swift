//
//  serviseAPI.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 17.01.2023.
//

import UIKit
import Alamofire
import RealmSwift
import SwiftyJSON

class ServiseAPI {
    
    let realm = try! Realm()
    private let baseURL = "https://api.vk.com/method"
    private let token = UserDefaults().value(forKey: "token") as! String
    private let userID = UserDefaults().value(forKey: "userID") as! String
    
    func getRequestFriends(completion: @escaping () -> ()) {
        
        let params: Parameters = [
            "access_token" : token,
            "user_id" : userID,
            "order" : "random",
            "fields" : "photo_200, online, status, bdate, country, city, sex",
            "v" : "5.131"
        ]
        
        AF.request(baseURL + Methods.friendsGet.rawValue, method: .get , parameters: params).responseData { responce in
            guard let data = responce.data,
                  let friends = try? JSONDecoder().decode(ResponseObject<Profiles>.self, from: data).response.items,
                  let user = self.realm.object(ofType: User.self, forPrimaryKey: Int(self.userID) ?? 0)
            else {
                print("Error request or decode JSON from Get Friends")
                return
            }
            
            if user.friends.isEmpty {
                try! self.realm.write{
                    user.friends = friends
                }
            } else if user.friends != friends {
                try! self.realm.write{
                    self.realm.add(friends, update: .modified)
                }
            }
            completion()
        }
    }
    
    func getRequestGroups(completion: @escaping () -> ()) {
        
        let params: Parameters = [
            "access_token" : token,
            "user_id" : userID,
            "extended" : "1",
            "fields" : "members_count, activity",
            "v" : "5.131"
        ]
        
        AF.request(baseURL + Methods.groupsGet.rawValue, method: .get , parameters: params).responseData { responce in
            guard let data = responce.data,
                  let groups = try? JSONDecoder().decode(ResponseObject<Groups>.self, from: data).response.items,
                  let user = self.realm.object(ofType: User.self, forPrimaryKey: Int(self.userID) ?? 0)
            else {
                print("Error request or decode JSON from Get Groups")
                return
            }
            
            if user.groups.isEmpty {
                try! self.realm.write{
                    user.groups = groups
                }
            } else if user.groups != groups {
                try! self.realm.write{
                    self.realm.add(groups, update: .modified)
                }
            }
            completion()
        }
    }
    
    func getRequestPhotos(ownerID: Int, completion: @escaping () -> ()) {
        let params: Parameters = [
            "access_token" : token,
            "owner_id" : String(ownerID),
            "album_id" : "profile",
            "extended" : "1",
            "v" : "5.131"
        ]
        
        AF.request(baseURL + Methods.photosGet.rawValue, method: .get, parameters: params).responseData { responce in
            guard let data = responce.data,
                  let photos = try? JSONDecoder().decode(ResponseObject<PhotoUserItems>.self, from: data).response.items
            else {
                print("Error request or decode JSON from Get Photos")
                return
            }
            
            try! self.realm.write {
                let profile = self.realm.object(ofType: ProfileItem.self, forPrimaryKey: ownerID)
                profile?.photos = photos
            }
            completion()
        }
    }
    
    func leaveGroup(idGroup: Int, completion: @escaping () -> ()) {
        
        let params: Parameters = [
            "access_token" : token,
            "group_id" : String(idGroup),
            "v" : "5.131"
        ]
        
        AF.request(baseURL + Methods.groupsLeave.rawValue, method: .post, parameters: params).responseData { responce in
            guard let data = responce.data,
                  let json = try? JSON(data: data)
            else { return }
            
            let isGroupDeleted = json["response"].rawValue as? Int ?? 0
            if isGroupDeleted == 1 {
                completion()
            }
        }
    }
    
    func joinGroup(idGroup: Int, completion: @escaping (_ Result: Bool) -> ()) {
        let params: Parameters = [
            "access_token" : token,
            "group_id" : String(idGroup),
            "v" : "5.131"
        ]
        
        AF.request(baseURL + Methods.groupsJoin.rawValue, method: .post, parameters: params).responseData { responce in
            guard let data = responce.data,
                  let json = try? JSON(data: data)
            else { return }
            
            print(json)
            let isGroupJoin = json["response"].rawValue as? Int ?? 0
            if isGroupJoin == 1 {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func searchGroups(searchText: String, completion: @escaping (List<GroupItem>?) -> ()) {
        let params: Parameters = [
            "access_token" : token,
            "user_id" : userID,
            "q" : searchText,
            "count" : "50",
            "v" : "5.131"
        ]
        
        AF.request(baseURL + Methods.searchGroupGet.rawValue, method: .get, parameters: params).responseData { responce in
            guard let data = responce.data else { return }
            let groups = try! JSONDecoder().decode(ResponseObject<Groups>.self, from: data).response.items
            
            completion(groups)
        }
    }
    
    func getRequestWall(method: Methods, parammeters: Parameters, completion: @escaping (Walls?) -> ()) {
        AF.request(baseURL + method.rawValue, method: .get, parameters: parammeters).responseData { responce in
            guard let data = responce.data else { return }
            let walls = try? JSONDecoder().decode(ResponseObject<Walls>.self, from: data).response
            
            completion(walls)
        }
    }
    
    func getRequestNewsfeed(method: Methods, parammeters: Parameters, completion: @escaping ([NewsFeedItem]?, [ProfileItem]?, [GroupItem]?, String?) -> ()) {
        AF.request(baseURL + method.rawValue, method: .get, parameters: parammeters).responseData { responce in
            guard let data = responce.data
            else {
                print("Error request or decode JSON from NewsFeed.get")
                return
            }
            print(JSON(data))
            
            let newsfeed = try! JSONDecoder().decode(ResponseObject<Newsfeed>.self, from: data).response
            
            let wall = newsfeed.items
            let friends = newsfeed.profiles
            let groups = newsfeed.groups
//            let nextFrom = newsfeed.nextForm
            
            completion(wall, friends, groups, nil)
        }
    }
    
    func postRequestLikeAndUnlike(post: AnyObject?, method: Methods, completion: @escaping (Int) -> ()) {
        var params: Parameters = [:]
        if let post = post as? WallItem {
            params = [
                "access_token" : token,
                "type" : "post",
                "item_id" : String(post.postID),
                "v" : "5.131"
            ]
        } else if let post = post as? NewsFeedItem {
            params = [
                "access_token" : token,
                "owner_id" : String(post.ownerID),
                "type" : "post",
                "item_id" : String(post.postID),
                "v" : "5.131"
            ]
        } else if let post = post as? PhotoItem {
            switch method {
            case .likesAdd:
                params = [
                    "access_token" : token,
                    "owner_id" : String(post.ownerID),
                    "type" : "photo",
                    "item_id" : String(post.photoID ?? 0),
                    "v" : "5.131"
                ]
            case .likesDelete:
                params = [
                    "access_token" : token,
                    "type" : "photo",
                    "owner_id" : String(post.ownerID),
                    "item_id" : String(post.photoID ?? 0),
                    "v" : "5.131"
                ]
            default:
                fatalError("ERROR REQUEST LIKE ACTION! *file* ServiceAPI, Check method")
            }
        } else {
            fatalError("ERROR REQUEST LIKE ACTION! *file* ServiceAPI, Check object")
        }
        
        AF.request(baseURL + method.rawValue, method: .post, parameters: params).responseData { response in
            guard let data = response.data else { return }
            let likes = try! JSONDecoder().decode(ResponseObject<NewLikesCount>.self, from: data).response
            
            completion(likes.count)
        }
    }
    
    final func loadUserData() {
        let params: Parameters = [
            "access_token" : token,
            "v" : "5.131"
        ]
        AF.request(baseURL + Methods.accountGetProfileInfo.rawValue, method: .get, parameters: params).responseData { response in
            guard let data = response.data,
                  let userInfo = try? JSONDecoder().decode(ResponseObject<User>.self, from: data).response
            else {
                print("Error request or decode JSON from get account info")
                print(JSON(response.data as Any))
                return
            }
            
            try! self.realm.write {
                self.realm.add(userInfo)
            }
        }
    }
    
    func updateOnlineStatus() {
        let params: Parameters = [
            "access_token" : token,
            "v" : "5.131"
        ]
        
        AF.request(baseURL + Methods.friendsGetOnline.rawValue, method: .get, parameters: params).responseData { response in
            guard let data = response.data,
                  let onlineFriends = JSON(data)["response"].rawValue as? [Int]
            else {
                print("Fail convertable to [Int]")
                return
            }
            if onlineFriends.isEmpty { return }
            
            for i in onlineFriends {
                if let friend = self.realm.object(ofType: ProfileItem.self, forPrimaryKey: i) {
                    try! self.realm.write {
                        friend.online = true
                    }
                } else {
                    self.realm.object(ofType: ProfileItem.self, forPrimaryKey: i)?.online = false
                }
            }
        }
    }
    
    
    
    enum Methods: String {
        case friendsGet = "/friends.get"
        case groupsGet = "/groups.get"
        case photosGet = "/photos.get"
        case likesAdd = "/likes.add"
        case likesDelete = "/likes.delete"
        case searchGroupGet = "/groups.search"
        case wallGet = "/wall.get"
        case newsfeedGet = "/newsfeed.get"
        case groupsLeave = "/groups.leave"
        case groupsJoin = "/groups.join"
        case accountGetProfileInfo = "/account.getProfileInfo"
        case friendsGetOnline = "/friends.getOnline"

    }
}



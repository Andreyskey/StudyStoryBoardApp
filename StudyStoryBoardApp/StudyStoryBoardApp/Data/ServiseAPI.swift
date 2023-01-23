//
//  serviseAPI.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 17.01.2023.
//

import UIKit
import Alamofire

class ServiseAPI {
    
    let baseUrl = "https://api.vk.com/method"
    
    func getRequestFriends(method: Methods, parammeters: Parameters, completion: @escaping ([ProfileItem]?) -> ()) {
        AF.request(baseUrl + method.rawValue, method: .get , parameters: parammeters).responseData { responce in
            guard let data = responce.data else { return }
            let friends = try! JSONDecoder().decode(ProfilesResponce.self, from: data).response.items
            
            completion(friends)
        }
    }
    
    func getRequestGroups(method: Methods, parammeters: Parameters, completion: @escaping ([GroupItem]?) -> ()) {
        AF.request(baseUrl + method.rawValue, method: .get , parameters: parammeters).responseData { responce in
            guard let data = responce.data else { return }
            let groups = try! JSONDecoder().decode(GroupsResponce.self, from: data).response.items
            
            completion(groups)
        }
    }
    
    func getRequestPhotos(method: Methods, parammeters: Parameters, completion: @escaping ([PhotoItem]?) -> ()) {
        AF.request(baseUrl + method.rawValue, method: .get, parameters: parammeters).responseData { responce in
            guard let data = responce.data else { return }
            let photos = try! JSONDecoder().decode(PhotosResponce.self, from: data).response.items
            
            completion(photos)
        }
    }
    
    func getRequestWall(method: Methods, parammeters: Parameters, completion: @escaping ([WallItem]?, [ProfileItem]?, [GroupItem]?) -> ()) {
        AF.request(baseUrl + method.rawValue, method: .get, parameters: parammeters).responseData { responce in
            guard let data = responce.data else { return }
            let decodeJson = try! JSONDecoder().decode(WallsResponse.self, from: data).response
            let wall = decodeJson.items
            let friends = decodeJson.profiles
            let groups = decodeJson.groups
            
            completion(wall, friends, groups)
        }
    }
    
    func getRequestNewsfeed(method: Methods, parammeters: Parameters, completion: @escaping ([NewsFeedItem]?, [ProfileItem]?, [GroupItem]?, String?) -> ()) {
        AF.request(baseUrl + method.rawValue, method: .get, parameters: parammeters).responseData { responce in
            guard let data = responce.data else { return }
            let newsfeed = try! JSONDecoder().decode(NewsfeedRespounce.self, from: data).response
            let wall = newsfeed.items
            let friends = newsfeed.profiles
            let groups = newsfeed.groups
            let nextFrom = newsfeed.nextForm
            
            completion(wall, friends, groups, nextFrom)
        }
    }
    
    func postRequestLikeAndUnlike(post: AnyObject?, method: Methods, completion: @escaping (String) -> ()) {
        var params: Parameters = [:]
        if let post = post as? WallItem {
            params = [
                "access_token" : Session.share.token,
                "type" : "post",
                "item_id" : String(post.postID),
                "v" : "5.131"
            ]
        } else if let post = post as? NewsFeedItem {
            params = [
                "access_token" : Session.share.token,
                "owner_id" : String(post.ownerID),
                "type" : "post",
                "item_id" : String(post.postID),
                "v" : "5.131"
            ]
        } else if let post = post as? PhotoItem {
            switch method {
            case .likesAdd:
                params = [
                    "access_token" : Session.share.token,
                    "owner_id" : String(post.ownerID),
                    "type" : "photo",
                    "item_id" : String(post.photoID ?? 0),
                    "v" : "5.131"
                ]
            case .likesDelete:
                params = [
                    "access_token" : Session.share.token,
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
        
        AF.request(baseUrl + method.rawValue, method: .post, parameters: params).responseData { response in
            guard let data = response.data else { return }
            let likes = try! JSONDecoder().decode(UpdateLikes.self, from: data).response
            
            completion(String(likes.count))
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
    }
}



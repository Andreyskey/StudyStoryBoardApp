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
    
    func getRequestFriends(method: String, parammeters: Parameters, completion: @escaping ([ProfileItem]?) -> ()) {
        AF.request(baseUrl + "/" + method, method: .get , parameters: parammeters).responseData { responce in
            guard let data = responce.data else { return }
            let friends = try? JSONDecoder().decode(ProfilesResponce.self, from: data).response.items
            
            completion(friends)
        }
    }
    
    func getRequestGroups(method: String, parammeters: Parameters, completion: @escaping ([GroupItem]?) -> ()) {
        AF.request(baseUrl + "/" + method, method: .get , parameters: parammeters).responseData { responce in
            guard let data = responce.data else { return }
            let groups = try? JSONDecoder().decode(GroupsResponce.self, from: data).response.items
            
            completion(groups)
        }
    }
    
    func getRequestPhotos(method: String, parammeters: Parameters, completion: @escaping ([PhotoItem]?) -> ()) {
        AF.request(baseUrl + "/" + method, method: .get, parameters: parammeters).responseData { responce in
            guard let data = responce.data else { return }
            let photos = try? JSONDecoder().decode(PhotosResponce.self, from: data).response.items
            
            completion(photos)
        }
    }
    
    func getRequestWall(method: String, parammeters: Parameters, completion: @escaping ([WallItem]?, [ProfileItem]?, [GroupItem]?) -> ()) {
        AF.request(baseUrl + "/" + method, method: .get, parameters: parammeters).responseData { responce in
            guard let data = responce.data else { return }
            let decodeJson = try! JSONDecoder().decode(WallsResponse.self, from: data).response
            let wall = decodeJson.items
            let friends = decodeJson.profiles
            let groups = decodeJson.groups
            
            completion(wall, friends, groups)
        }
    }
    
    func postRequestLikeAndUnlike(post: WallItem, method: ActionLike, completion: @escaping (String) -> ()) {
        let params: Parameters = [
            "access_token" : Session.share.token,
            "type" : "post",
            "item_id" : String(post.postID),
            "v" : "5.131"
        ]
        
        AF.request(baseUrl + "/" + method.rawValue, method: .post, parameters: params).responseData { response in
            guard let data = response.data else { return }
            let likes = try! JSONDecoder().decode(UpdateLikes.self, from: data).response.count
            
            completion(String(likes))
        }
        
    }
    
    enum ActionLike: String {
        case like = "/likes.add"
        case unlike = "/likes.delete"
    }
    
}

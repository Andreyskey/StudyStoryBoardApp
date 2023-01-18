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
    
    func getRequestFriends(method: String, parammeters: Parameters, completion: @escaping ([Friend]?) -> ()) {
        AF.request(baseUrl + "/" + method, method: .get , parameters: parammeters).responseData { responce in
            guard let data = responce.data else { return }
            let friends = try? JSONDecoder().decode(AllResponceFriends.self, from: data).response.items
            
            completion(friends)
        }
    }
    
    func getRequestGroups(method: String, parammeters: Parameters, completion: @escaping ([Group]?) -> ()) {
        AF.request(baseUrl + "/" + method, method: .get , parameters: parammeters).responseData { responce in
            guard let data = responce.data else { return }
            let groups = try? JSONDecoder().decode(AllGroupsResponce.self, from: data).response.items
            
            completion(groups)
        }
    }
    
    func getRequestPhotos(method: String, parammeters: Parameters, completion: @escaping ([PhotoUser]?) -> ()) {
        AF.request(baseUrl + "/" + method, method: .get, parameters: parammeters).responseData { responce in
            guard let data = responce.data else { return }
            let photos = try! JSONDecoder().decode(AllResponcePhoto.self, from: data).response.items
            
            completion(photos)
        }
        
//        AF.request(baseUrl + "/" + method, method: .get , parameters: parammeters).responseData { responce in
//            guard let data = responce.data else { return }
//            let photos = try? JSONDecoder().decode(AllResponcePhoto.self, from: data).response.items
//
//            completion(photos)
//        }
    }
}
//
//
//let paramsFriend: Parameters = [
//    "access_token" : Session.share.token,
//    "user_id" : Session.share.userId,
//    "order" : "random",
//    "count" : "8",
//    "fields" : "nickname",
//    "v" : "5.131"
//]
//
//let paramsGroup: Parameters = [
//    "access_token" : Session.share.token,
//    "user_id" : Session.share.userId,
//    "extended" : "1",
//    "count" : "8",
//    "v" : "5.131"
//]
//
//let paramsPhoto: Parameters = [
//    "access_token" : Session.share.token,
//    "owner_id" : Session.share.userId,
//    "album_id" : "profile",
//    "count" : "8",
//    "rev" : "0",
//    "v" : "5.131"
//]
//
//let paramsSearch: Parameters = [
//    "access_token" : Session.share.token,
//    "user_id" : Session.share.userId,
//    "q" : "apple",
//    "type" : "page",
//    "count" : "8",
//    "v" : "5.131"
//]
//
//getRequest(method: "friends.get", parammeters: paramsFriend)
//getRequest(method: "groups.search", parammeters: paramsSearch)
//getRequest(method: "groups.get", parammeters: paramsGroup)
//getRequest(method: "photos.get", parammeters: paramsPhoto)

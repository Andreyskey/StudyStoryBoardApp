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
            let friends = try! JSONDecoder().decode(AllResponceFriends.self, from: data).response.items
            
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
            let photos = try? JSONDecoder().decode(AllResponcePhoto.self, from: data).response.items
            
            completion(photos)
        }
    }
    
    func getRequestWall(method: String, parammeters: Parameters, completion: @escaping ([Wall]?, [Friend]?, [Group]?) -> ()) {
        AF.request(baseUrl + "/" + method, method: .get, parameters: parammeters).responseData { responce in
            guard let data = responce.data else { return }
            let decodeJson = try! JSONDecoder().decode(AllResponceWalls.self, from: data).response
            let wall = decodeJson.items
            let friends = decodeJson.profiles
            let groups = decodeJson.groups
            
            completion(wall, friends, groups)
        }
    }
    
}

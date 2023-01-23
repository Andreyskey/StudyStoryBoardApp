//
//  Data.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 29.10.2022.
//

import UIKit

class AllResponceFriends: Decodable {
    var response: FriendsResponce
}

class FriendsResponce: Decodable {
    var items: [Friend]
}

class Friend: Decodable {
    var id: Int = 0
    var online: Int = 0
    var firstName: String = ""
    var lastName: String = ""
    var avatar: String = ""
    var status: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case online
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar = "photo_100"
        case status
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(Int.self, forKey: .id)
        self.online = try values.decode(Int.self, forKey: .online)
        self.firstName = try values.decode(String.self, forKey: .firstName)
        self.lastName = try values.decode(String.self, forKey: .lastName)
        self.avatar = try values.decode(String.self, forKey: .avatar)
        self.status = try? values.decode(String.self, forKey: .status)
    }
}

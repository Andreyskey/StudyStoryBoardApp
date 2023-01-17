//
//  Group.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 14.10.2022.
//

import UIKit

class AllGroupsResponce: Decodable {
    var response: GroupsResponce
}

class GroupsResponce: Decodable {
    var items = [Group]()
}

class Group: Decodable {
    var id = 0
    var activity: String?
    var name = ""
    var subscribers: Int?
    var avatar = ""
    
    enum CodingKeys: String, CodingKey {
        case activity
        case name
        case subscribers = "members_count"
        case id
        case avatar = "photo_200"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(Int.self, forKey: .id)
        self.activity = try? values.decode(String.self, forKey: .activity)
        self.name = try values.decode(String.self, forKey: .name)
        self.subscribers = try? values.decode(Int.self, forKey: .subscribers)
        self.avatar = try values.decode(String.self, forKey: .avatar)
    }
}

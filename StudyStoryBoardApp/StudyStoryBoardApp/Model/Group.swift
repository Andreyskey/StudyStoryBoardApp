//
//  Group.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 14.10.2022.
//

import UIKit

struct GroupsResponce: Decodable {
    var response: Groups
}

struct Groups: Decodable {
    var items = [GroupItem]()
}

struct GroupItem: Decodable {
    var id: Int
    var activity: String?
    var name: String
    var subscribers: Int?
    var avatar: String
    
    enum CodingKeys: String, CodingKey {
        case activity, id, name
        case subscribers = "members_count"
        case avatar = "photo_200"
    }
}

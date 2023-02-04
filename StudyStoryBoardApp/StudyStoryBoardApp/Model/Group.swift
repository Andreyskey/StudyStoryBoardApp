//
//  Group.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 14.10.2022.
//

import UIKit
import RealmSwift

class Groups: Decodable {
    var items: List<GroupItem>
}

class GroupItem: Object, Decodable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var activity: String?
    @Persisted var name: String = ""
    @Persisted var subscribers: Int?
    @Persisted var avatar: String = ""
    @Persisted var isMember: Bool = false
    
    
    enum CodingKeys: String, CodingKey {
        case activity, id, name
        case subscribers = "members_count"
        case avatar = "photo_200"
        case isMember = "is_member"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.activity = try? container.decode(String.self, forKey: .activity)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.subscribers = try? container.decode(Int.self, forKey: .subscribers)
        self.avatar = try container.decode(String.self, forKey: .avatar)
        
        let isMember = try container.decode(Int.self, forKey: .isMember)
        self.isMember = isMember == 1
    }
}

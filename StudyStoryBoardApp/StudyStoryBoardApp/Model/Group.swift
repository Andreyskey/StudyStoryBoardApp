//
//  Group.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 14.10.2022.
//

import UIKit
import RealmSwift

class Groups: Object, Decodable {
    @Persisted(primaryKey: true) var objectID: Int = 0
    @Persisted var items: List<GroupItem>
    
    enum CodingKeys: CodingKey {
        case items
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._items = try container.decode(Persisted<List<GroupItem>>.self, forKey: .items)
    }
}

class GroupItem: Object, Decodable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var activity: String?
    @Persisted var name: String = ""
    @Persisted var subscribers: Int?
    @Persisted var avatar: String = ""
    
    enum CodingKeys: String, CodingKey {
        case activity, id, name
        case subscribers = "members_count"
        case avatar = "photo_200"
    }
}

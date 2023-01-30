//
//  Group.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 14.10.2022.
//

import UIKit
import RealmSwift

class Groups: Decodable {
    var items = [GroupItem]()
}

class GroupItem: Object, Decodable {
    @Persisted var id: Int
    @Persisted var activity: String?
    @Persisted var name: String
    @Persisted var subscribers: Int?
    @Persisted var avatar: String
    
    enum CodingKeys: String, CodingKey {
        case activity, id, name
        case subscribers = "members_count"
        case avatar = "photo_200"
    }
}

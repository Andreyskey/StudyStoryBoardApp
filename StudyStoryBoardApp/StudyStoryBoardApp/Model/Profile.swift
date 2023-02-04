//
//  Data.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 29.10.2022.
//

import UIKit
import RealmSwift

class Profiles: Object, Decodable {
    @Persisted(primaryKey: true) var objectID: Int = 0
    @Persisted var items: List<ProfileItem>
    
    enum CodingKeys: CodingKey {
        case items
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._items = try container.decode(Persisted<List<ProfileItem>>.self, forKey: .items)
    }
}

class ProfileItem: Object, Decodable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var online: Bool = false
    @Persisted var firstName: String = ""
    @Persisted var lastName: String = ""
    @Persisted var avatar: String = ""
    @Persisted var status: String?
    @Persisted var albumPhoto: PhotoUserItems?
    
    enum CodingKeys: String, CodingKey {
        case id
        case online
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar = "photo_200"
        case status
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        let online = try? container.decode(Int.self, forKey: .online)
        self.online = ((online ?? 0) == 1)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.avatar = try container.decode(String.self, forKey: .avatar)
        self.status = try? container.decodeIfPresent(String.self, forKey: .status)
    }
}

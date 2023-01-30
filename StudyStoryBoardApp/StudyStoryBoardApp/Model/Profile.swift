//
//  Data.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 29.10.2022.
//

import UIKit
import RealmSwift

class Profiles: Decodable {
    var items: [ProfileItem]
}

class ProfileItem: Object, Decodable {
    @Persisted var id: Int
    @Persisted var online: Bool
    @Persisted var firstName: String
    @Persisted var lastName: String
    @Persisted var avatar: String
    @Persisted var status: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case online
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar = "photo_200"
        case status
    }
    
    required init(from decoder: Decoder) throws {
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

//
//  Data.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 29.10.2022.
//

import UIKit

class ProfilesResponce: Decodable {
    var response: Profiles
}

class Profiles: Decodable {
    var items: [ProfileItem]
}

class ProfileItem: Decodable {
    var id: Int
    var online: Bool
    var firstName: String
    var lastName: String
    var avatar: String
    var status: String?
    
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

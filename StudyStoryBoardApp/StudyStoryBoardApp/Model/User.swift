//
//  User.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 03.02.2023.
//

import UIKit
import RealmSwift

class User: Object, Decodable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var firstName: String = ""
    @Persisted var lastName: String = ""
    @Persisted var status: String?
    @Persisted var birthDayDate: String?
    @Persisted var gender: String
    @Persisted var friends: List<ProfileItem>
    @Persisted var groups: List<GroupItem>
    
    enum CodingKeys: String, CodingKey {
        case id, status
        case firstName = "first_name"
        case lastName = "last_name"
        case gender = "sex"
        case birthDayDate = "bdate"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.status = try container.decode(String?.self, forKey: .status)
        self.birthDayDate = try container.decode(String?.self, forKey: .birthDayDate)
        
        let sex = try container.decode(Int.self, forKey: .gender)
        switch sex {
        case 1:
            self.gender = "Женчина"
        case 2:
            self.gender = "Мужчина"
        default:
            self.gender = "Не указано"
        }
    }
}

//
//  Data.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 29.10.2022.
//

import UIKit
import RealmSwift

class Profiles: Decodable {
    var items: List<ProfileItem>?
}

class ProfileItem: Object, Decodable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var online: Bool = false
    @Persisted var firstName: String = ""
    @Persisted var lastName: String = ""
    @Persisted var avatar: String = ""
    @Persisted var status: String?
    @Persisted var birthDayDate: String?
    @Persisted var gender: String
    @Persisted var city: String?
    @Persisted var country: String?
    @Persisted var photos: List<PhotoItem>
    
    
    enum CodingKeys: String, CodingKey {
        case id, status, online, city, country
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar = "photo_200"
        case birthDayDate = "bdate"
        case gender = "sex"
    }
    
    enum CountryCityKeys: String, CodingKey {
        case title
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.avatar = try container.decode(String.self, forKey: .avatar)
        self.status = try? container.decode(String.self, forKey: .status)
        self.birthDayDate = try? container.decode(String?.self, forKey: .birthDayDate)
        
        let cityContainer = try? container.nestedContainer(keyedBy: CountryCityKeys.self, forKey: .city)
        self.city = try cityContainer?.decode(String?.self, forKey: .title)
        
        let countryContainer = try? container.nestedContainer(keyedBy: CountryCityKeys.self, forKey: .country)
        self.country = try countryContainer?.decode(String?.self, forKey: .title)
        
        let online = try? container.decode(Int.self, forKey: .online)
        self.online = (online == 1)
        
        let sex = try? container.decode(Int.self, forKey: .gender)
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

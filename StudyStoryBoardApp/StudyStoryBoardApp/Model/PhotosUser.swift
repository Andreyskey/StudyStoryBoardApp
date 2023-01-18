//
//  File.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 17.01.2023.
//

import UIKit

class AllResponcePhoto: Decodable {
    var response: ResponcePhotoUser
}

class ResponcePhotoUser: Decodable {
    var items = [PhotoUser]()
}

class PhotoUser: Decodable {
    var sizes = [Size]()
}

class Size: Decodable {
    var type = ""
    var url = ""
    
    enum CodingKeys: String, CodingKey {
        case type, url
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.type = try values.decode(String.self, forKey: .type)
        self.url = try values.decode(String.self, forKey: .url)
    }
}

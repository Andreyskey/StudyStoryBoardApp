//
//  Wall.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 19.01.2023.
//

import UIKit

class AllResponceWalls: Decodable {
    var response: WallResponce
}

class WallResponce: Decodable {
    var items: [Wall]
    var profiles = [Friend]()
    var groups = [Group]()
}

class Wall: Decodable {
    var ownerId = 0
    var date = 0
    var comments: Int?
    var reposts: Int?
    var photosProfile: String?
    var photosGroups: String?
    var likes: Int?
    var views: Int?
    var text = ""
//    var heightPhoto = 0
//    var weightPhoto = 0

    
    enum CodingKeys: String, CodingKey {
        case ownerID = "from_id"
        case date
        case text
        case comments
        case views
        case likes
        case reposts
        case attachments
        case copyHistory = "copy_history"
    }
    
    
    enum CommentsKeys: String, CodingKey {
        case count
    }
    
    
    enum AttachmentsKeys: String, CodingKey {
        case photo
    }
    enum PhotoKeys: String, CodingKey {
        case sizes
        case ownerID = "owner_id"
    }
    enum SizesKeys: String, CodingKey {
        case url
    }
    
    
    enum LikesKeys: String, CodingKey {
        case count
    }
    
    
    enum ShareKeys: String, CodingKey {
        case count
    }
    
    
    enum ViewsKeys: String, CodingKey {
        case count
    }


    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try values.decode(Int.self, forKey: .date)
        self.text = try values.decode(String.self, forKey: .text)
        let ownerID = try values.decode(Int.self, forKey: .ownerID)
        
        let attach = try? values.decode([Attachments].self, forKey: .attachments)
        self.photosProfile = attach?.first?.photo.sizes.last?.url
        
        let copyHistory = try? values.decode([CopyHistory].self, forKey: .copyHistory)
        self.photosGroups = copyHistory?.first?.attachments.first?.photo.sizes.last?.url
        self.ownerId = copyHistory?.first?.ownerID ?? ownerID
        
        let likes = try values.nestedContainer(keyedBy: LikesKeys.self, forKey: .likes)
        self.likes = try? likes.decode(Int.self, forKey: .count)
        
        let comments = try values.nestedContainer(keyedBy: CommentsKeys.self, forKey: .comments)
        self.comments = try? comments.decode(Int.self, forKey: .count)
        
        let reposts = try values.nestedContainer(keyedBy: ShareKeys.self, forKey: .reposts)
        self.reposts = try? reposts.decode(Int.self, forKey: .count)
        
        let view = try? values.nestedContainer(keyedBy: ViewsKeys.self, forKey: .views)
        self.views = try view?.decode(Int.self, forKey: .count)
    }
}

class CopyHistory: Decodable {
    var attachments: [Attachments]
    var ownerID = 0
    
    enum CodingKeys: String, CodingKey {
        case attachments
        case ownerID = "owner_id"
    }
}

class Attachments: Decodable {
    var photo: Photo
}

class Photo: Decodable {
    var sizes: [SizesImage]
}

class SizesImage: Decodable {
    var url = ""
    var type = ""
//    var height = 0
//    var wight = 0
}

//
//  File.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 17.01.2023.
//

import UIKit
import RealmSwift

class PhotoUserItems: Decodable {
    var items: List<PhotoItem>
}


class PhotoItem: EmbeddedObject, Decodable {
    @Persisted var ownerID: Int
    @Persisted var sizes: List<SizePhoto>
    @Persisted var likes: Likes?
    @Persisted var comments: Int = 0
    @Persisted var reposts: Int = 0
    @Persisted var photoID: Int?
    
    enum CodingKeys: String, CodingKey {
        case ownerID = "owner_id"
        case photoID = "id"
        case sizes, likes, comments, reposts
    }
    
    enum CountKeys: String, CodingKey {
        case count
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.ownerID = try container.decode(Int.self, forKey: .ownerID)
        self.photoID = try container.decode(Int?.self, forKey: .photoID)
        self.sizes = try container.decode(List<SizePhoto>.self, forKey: .sizes)
        self.likes = try? container.decode(Likes.self, forKey: .likes)
        
        let commentsContainer = try? container.nestedContainer(keyedBy: CountKeys.self, forKey: .comments)
        self.comments = (try? commentsContainer?.decode(Int.self, forKey: .count)) ?? 0
        
        let repostsContainer = try? container.nestedContainer(keyedBy: CountKeys.self, forKey: .reposts)
        self.reposts = (try? repostsContainer?.decode(Int.self, forKey: .count)) ?? 0
        
        
    }
}

class SizePhoto: EmbeddedObject, Decodable {
    @Persisted var url: String
    @Persisted var width: Int
    @Persisted var height: Int
}

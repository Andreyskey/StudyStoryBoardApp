//
//  File.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 17.01.2023.
//

import UIKit
import RealmSwift

class PhotoUserItems: EmbeddedObject, Decodable {
    @Persisted var items: List<PhotoItem>
}

class PhotoItem: EmbeddedObject, Decodable {
    @Persisted var ownerID: Int
    @Persisted var accessKey: String?
    @Persisted var sizes: List<SizePhoto>
    @Persisted var likes: Likes?
    @Persisted var comments: Comments?
    @Persisted var reposts: Reposts?
    @Persisted var photoID: Int?
    
    enum CodingKeys: String, CodingKey {
        case ownerID = "owner_id"
        case accessKey = "access_key"
        case photoID = "id"
        case sizes, likes, comments, reposts
    }
}

class SizePhoto: EmbeddedObject, Decodable {
    @Persisted var url: String
    @Persisted var width: Int
    @Persisted var height: Int
}

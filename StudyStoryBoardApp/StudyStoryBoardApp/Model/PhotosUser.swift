//
//  File.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 17.01.2023.
//

import UIKit
import RealmSwift

class PhotoUserItems: Decodable {
    var items: [PhotoItem]
}

class PhotoItem: Object, Decodable {
    @Persisted var ownerID: Int
    @Persisted var accessKey: String?
    var sizes: [SizePhoto]
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
    var url: String
    var type: String
    var width: Int
    var height: Int
}

//
//  File.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 17.01.2023.
//

import UIKit

class PhotosResponce: Decodable {
    var response: PhotoUserItems
}

class PhotoUserItems: Decodable {
    var items: [PhotoItem]
}

class PhotoItem: Decodable {
    var ownerID: Int
    var accessKey: String?
    var sizes: [SizePhoto]
    var likes: Likes?
    var comments: Comments?
    var reposts: Reposts?
    var photoID: Int?
    
    enum CodingKeys: String, CodingKey {
        case ownerID = "owner_id"
        case accessKey = "access_key"
        case photoID = "id"
        case sizes, likes, comments, reposts
    }
}

class SizePhoto: Decodable {
    var url: String
    var type: String
    var width: Int
    var height: Int
}

//
//  File.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 17.01.2023.
//

import UIKit

struct PhotosResponce: Decodable {
    var response: PhotoUserItems
}

struct PhotoUserItems: Decodable {
    var items: [PhotoItem]
}

struct PhotoItem: Decodable {
    var ownerID: Int
    var accessKey: String
    var sizes: [SizePhoto]
    
    enum CodingKeys: String, CodingKey {
        case ownerID = "owner_id"
        case accessKey = "access_key"
        case sizes
    }
}

struct SizePhoto: Decodable {
    var url: String
    var type: String
    var width: Int
    var height: Int
}

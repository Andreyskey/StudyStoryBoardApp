//
//  Wall.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 19.01.2023.
//

import UIKit

struct WallsResponse: Decodable {
    var response: Walls
}

struct Walls: Decodable {
    var items: [WallItem]
    var profiles: [ProfileItem]
    var groups: [GroupItem]
}

struct WallItem: Decodable {
    var postID: Int
    var fromID: Int
    var date: Date
    var comments: Comments
    var copyHistory: [CopyHistory]?
    var attachments: [Attachments]?
    var likes: Likes
    var reposts: Reposts
    var text: String
    var views: Views?
    
    enum CodingKeys: String, CodingKey {
        case postID = "id"
        case fromID = "from_id"
        case copyHistory = "copy_history"
        case date, comments, attachments, likes, reposts, text, views
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fromID = try container.decode(Int.self, forKey: .fromID)
        self.copyHistory = try? container.decodeIfPresent([CopyHistory].self, forKey: .copyHistory)
        self.postID = try container.decode(Int.self, forKey: .postID)
        
        let timeInterval = try container.decode(Double.self, forKey: .date)
        self.date = Date(timeIntervalSince1970: timeInterval)
        
        self.comments = try container.decode(Comments.self, forKey: .comments)
        self.attachments = try? container.decodeIfPresent([Attachments].self, forKey: .attachments)
        self.likes = try container.decode(Likes.self, forKey: .likes)
        self.reposts = try container.decode(Reposts.self, forKey: .reposts)
        self.text = try container.decode(String.self, forKey: .text)
        self.views = try? container.decode(Views?.self, forKey: .views)
    }
}

struct CopyHistory: Decodable {
    var attachments: [Attachments]
}

struct Attachments: Decodable {
    var photo: PhotoItem?
}

struct Comments: Decodable {
    var count: Int
}

struct Likes: Decodable {
    var count: Int
    var canLike: Bool
    
    enum CodingKeys: String, CodingKey {
        case count
        case canLike = "can_like"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.count = try container.decode(Int.self, forKey: .count)
        let canLike = try container.decode(Int.self, forKey: .canLike)
        self.canLike = (canLike == 1)
    }
}

struct Reposts: Decodable {
    var count: Int
}

struct Views: Decodable {
    var count: Int?
}

//
//  NewsfeedPost.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 22.01.2023.
//

import UIKit
import RealmSwift

class Newsfeed: Decodable {
    var items: [NewsFeedItem]
    var profiles: [ProfileItem]
    var groups: [GroupItem]
    var nextForm: String
    
    enum CodingKeys: String, CodingKey {
        case items, profiles, groups
        case nextForm = "next_from"
    }
}

class NewsFeedItem: Decodable {
    var sourseID: Int
    var date: Date
    var comments: Comments?
    var attachments: [Attachments]?
    var likes: Likes
    var reposts: Reposts
    var text: String
    var views: Views?
    var postID: Int
    var ownerID: Int
    
    enum CodingKeys: String, CodingKey {
        case date, comments, attachments, likes, reposts, text, views
        case postID = "post_id"
        case sourseID = "source_id"
        case ownerID = "owner_id"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let timeInterval = try container.decode(Double.self, forKey: .date)
        self.date = Date(timeIntervalSince1970: timeInterval)
        
        self.comments = try? container.decode(Comments?.self, forKey: .comments)
        self.attachments = try? container.decode([Attachments]?.self, forKey: .attachments)
        self.likes = try container.decode(Likes.self, forKey: .likes)
        self.reposts = try container.decode(Reposts.self, forKey: .reposts)
        self.text = try container.decode(String.self, forKey: .text)
        self.views = try container.decode(Views.self, forKey: .views)
        self.postID = try container.decode(Int.self, forKey: .postID)
        self.sourseID = try container.decode(Int.self, forKey: .sourseID)
        self.ownerID = try container.decode(Int.self, forKey: .ownerID)
    }
}

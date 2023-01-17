////
////  PostModel.swift
////  StudyStoryBoardApp
////
////  Created by Андрей Волков on 01.11.2022.
////
//
//import UIKit
//
//class AllResponceWall: Decodable {
//    var responce: WallResponce
//}
//
//class WallResponce: Decodable {
//    var items = [Wall]()
//}
//
//class Wall: Decodable {
//    var date = 0
//    var ownerId = 0
//    var comments = 0
//    var likes = 0
//    var reposts = 0
//    var text: String?
//    var image: UIImage?
//
//    enum CodingKeys: String, CodingKey {
//        case date
//        case ownerId = "owner_id"
//    }
//
//    enum CommentsKeys: String, CodingKey {
//        case comments = "count"
//    }
//
//    enum LikesKeys: String, CodingKey {
//        case likes = "count"
//    }
//
//    enum RepostsKeys: String, CodingKey {
//        case comments = "count"
//    }
//
//    convenience required init(from decoder: Decoder) throws {
//
//    }
////}
//
//

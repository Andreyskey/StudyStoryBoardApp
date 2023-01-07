//
//  PostModel.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 01.11.2022.
//

import UIKit

struct Post {
    var name: String
    var imageProfile: UIImage
    let timePost: String
    var textPost: String?
    var ImagePost: [String?]
    var countLikes: Int
    var isLiked: Bool = false
    var countComment: Int
    var countShare: Int
    var seesCount: String
}

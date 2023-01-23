//
//  UpdateLikes.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 20.01.2023.
//

import UIKit

class UpdateLikes: Decodable {
    var response: NewLikes
}

class NewLikes: Decodable {
    var count: Int
    
    enum CodingKeys: String, CodingKey {
        case count = "likes"
    }
}

//
//  File.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 14.10.2022.
//

import UIKit

struct Friend {
    let fullName: String
    let image: String
    let isFrom: String
    var isOnline : Bool
    let albumImages: [String]
    let lastMessage: String
}

extension Friend: Equatable {}

func ==(lhs: Friend, rhs: Friend) -> Bool {
    let areEqual = lhs.fullName == rhs.fullName &&
        lhs.image == rhs.image &&
        lhs.albumImages == rhs.albumImages
        
    return areEqual
}

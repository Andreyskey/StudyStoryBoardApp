//
//  Group.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 14.10.2022.
//

import UIKit

struct Group {
    let name: String
    let image: String
    let infoGroup: String
}

extension Group: Equatable {}

func ==(lhs: Group, rhs: Group) -> Bool {
    let areEqual = lhs.name == rhs.name &&
        lhs.image == rhs.image
        
    return areEqual
}

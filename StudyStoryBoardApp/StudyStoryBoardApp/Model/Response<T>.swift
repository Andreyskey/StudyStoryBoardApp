//
//  File.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 24.01.2023.
//

import UIKit
import RealmSwift

class ResponseObject<T: Decodable>: Decodable {
    var response: T
}

//
//  File.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 24.01.2023.
//

import UIKit

class ResponseObject<T: Decodable>: Decodable {
    var response: T
}

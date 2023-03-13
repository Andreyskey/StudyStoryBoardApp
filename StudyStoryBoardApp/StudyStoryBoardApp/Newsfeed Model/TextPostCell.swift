//
//  TextPostCell.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 18.02.2023.
//

import UIKit

class TextPostCell: UITableViewCell {

    @IBOutlet weak var descriptionPost: UILabel!
    
    func addTextPost(_ text: String) {
        descriptionPost.text = text
    }
    
    // реалтзовать показ скрытого текста
    
    override func prepareForReuse() {
        descriptionPost.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

//
//  ImagesPostCell.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 18.02.2023.
//

import UIKit

class ImagesPostCell: UITableViewCell {

    @IBOutlet weak var imagesPost: UIImageView!
    
    func addImages(image: String) {
        // заменить на sdwebview
        imagesPost.image = UIImage(named: image)
    }
    
    override func prepareForReuse() {
        imagesPost.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

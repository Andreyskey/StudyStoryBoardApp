//
//  ShowImageCollectionViewCell.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 08.01.2023.
//

import UIKit

class ShowImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    
    func configurate(img: String) {
        image.image = UIImage(named: img)
    }
    
    func clearCell() {
        image.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clearCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
    }

}

//
//  ShowImageCollectionViewCell.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 08.01.2023.
//

import UIKit

class ShowImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    
    func configurate(imageUrl: String?) {
        image.sd_setImage(with: URL(string: imageUrl ?? ""))
    }
    
    func setup() {
    }
    
    func clearCell() {
        image.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        clearCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
    }

}

//
//  CustomCollectionViewCell.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 14.10.2022.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var img: UIImageView!
    
    func configCell(image: UIImage?) {
        guard let image = image
        else { return }
        
        img.image = image
    }
    
    func clearCell() {
        img = nil
    }
    
    override func prepareForReuse() {
        clearCell()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}

//
//  CustomCollectionViewCell.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 14.10.2022.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var img: UIImageView!
    
    func configCell(imageUrl: String?) {
        img.sd_setImage(with: URL(string: imageUrl ?? ""), placeholderImage: nil, options: [.progressiveLoad])
    }
    
    func clearCell() {
        img.image = nil
    }
    
    override func prepareForReuse() {
        clearCell()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}

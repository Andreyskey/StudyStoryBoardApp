//
//  HeaderPostCell.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 18.02.2023.
//

import UIKit
import SDWebImage

class HeaderPostCell: UITableViewCell {

    @IBOutlet weak var backroundViewHeader: UIView!
    @IBOutlet weak var nameProfile: UILabel!
    @IBOutlet weak var photoProfile: UIImageView!
    @IBOutlet weak var timePublished: UILabel!
    
    
    func configurate(avatar: String, name: String, timePublic: Date) {
        let url = URL(string: avatar)
        photoProfile.sd_setImage(with: url)
        timePublished.text = timePublic.formatted()
        nameProfile.text = name
    }
    
    func clearCell() {
        photoProfile.image = nil
        timePublished.text = nil
        nameProfile.text = nil
    }
    
    override func prepareForReuse() {
        clearCell()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backroundViewHeader.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backroundViewHeader.layer.cornerRadius = 20
        photoProfile.layer.cornerRadius = 24
    }
}

//
//  CustomTableViewCell.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 14.10.2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var photoProfile: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    func configurationCell(photo: UIImage, fullName: String) {
        photoProfile.image = photo
        name.text = fullName
    }
    
    // Установка параментров внешнего вида ячейки
    func setup() {
        photoProfile.layer.cornerRadius = photoProfile.frame.width / 2
        photoProfile.clipsToBounds = true
    }
    
    // Очистка ячейки
    func clearCell() {
        photoProfile = nil
        name = nil
    }
    
    // Переиспользование ячейки
    override func prepareForReuse() {
        clearCell()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
}

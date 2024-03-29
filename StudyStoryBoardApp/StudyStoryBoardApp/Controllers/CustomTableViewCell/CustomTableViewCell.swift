//
//  CustomTableViewCell.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 14.10.2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var isFrom: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var isOnline: UIView!
    @IBOutlet weak var isOnlineSubview: UIView!
    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var topImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var topOnlineConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomOnlineConstraint: NSLayoutConstraint!
    
    
    func configurationCell(object: Any) {
        
        
        if let friend = object as? ProfileItem {
            imageProfile.sd_setImage(with: URL(string: friend.avatar))
            fullName.text = friend.firstName + " " + friend.lastName
            isOnline.isHidden = !friend.online
            
            isFrom.numberOfLines = 1
            isFrom.text = friend.status
        }
        
        
        if let group = object as? GroupItem {
            
            imageProfile.sd_setImage(with: URL(string: group.avatar))
            fullName.text = group.name
            isFrom.text = group.activity
            
            topImageConstraint.constant = 16
            topOnlineConstraint.constant = 50
            bottomOnlineConstraint.constant = 16
            bottomImageConstraint.constant = 16
        }
    }
    
    // Установка параментров внешнего вида ячейки
    func setup() {
        imageProfile.layer.cornerRadius = imageProfile.frame.width / 2
        imageProfile.clipsToBounds = true
        isOnline.layer.cornerRadius = isOnline.frame.width / 2
        isOnlineSubview.layer.cornerRadius = isOnlineSubview.frame.width / 2
        
        
        var backroundConfig = UIBackgroundConfiguration.listGroupedCell()
        backroundConfig.cornerRadius = 20
        backroundConfig.strokeColor = UIColor(red: 0.902, green: 0.945, blue: 0.965, alpha: 1)
        backroundConfig.strokeWidth = 1
        self.backgroundConfiguration = backroundConfig
    }
    
    // Очистка ячейки
    func clearCell() {
        imageProfile.image = nil
        fullName.text = nil
        isFrom.text = nil
        topImageConstraint.constant = 8
        topOnlineConstraint.constant = 42
        bottomOnlineConstraint.constant = 8
        bottomImageConstraint.constant = 8
        isOnline.isHidden = true
    }
    
    // Переиспользование ячейки
    override func prepareForReuse() {
        clearCell()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        clearCell()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

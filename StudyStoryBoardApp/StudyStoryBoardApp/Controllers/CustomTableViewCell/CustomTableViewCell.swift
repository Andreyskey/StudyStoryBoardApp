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
    
    
    func configurationCell(friend: Friend?, group: Group?, isLast: Bool = false, isFirst: Bool = false, isMessage: Bool = false) {
        
        if let friend = friend {
            if isFirst {
                topImageConstraint.constant = 16
                topOnlineConstraint.constant = 50
            }
            if isLast {
                bottomOnlineConstraint.constant = 16
                bottomImageConstraint.constant = 16
            }
            
            if friend.isOnline {
                isOnline.isHidden = false
            }
            
            imageProfile.image = UIImage(named: friend.image)!
            fullName.text = friend.fullName
            
            if isMessage {
                isFrom.text = friend.lastMessage
            } else {
                isFrom.text = friend.isFrom
            }
        }
        
        if let group = group {
            topImageConstraint.constant = 16
            topOnlineConstraint.constant = 50
            bottomOnlineConstraint.constant = 16
            bottomImageConstraint.constant = 16
            
            imageProfile.image = UIImage(named: group.image)!
            fullName.text = group.name
            isFrom.text = group.infoGroup
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

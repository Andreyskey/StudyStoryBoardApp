//
//  LikeControl.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 17.10.2022.
//

import UIKit

@IBDesignable class LikeControl: UIControl {
    
    var isLiked: Bool = false
    var countLikes: Int = 0
    
    let button = UIButton(type: .system)
    
    
    func setupButton() {
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.setTitle(String(countLikes), for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.lightGray, for: .normal)
        button.tintColor = .lightGray
        
        button.setTitleColor(.systemRed, for: .selected)
        button.addTarget(self, action: #selector(liked(_:)), for: .touchUpInside)
        
        self.addSubview(button)
    }
    
    @objc func liked(_ sender: UIButton) {
        if isLiked {
            isLiked = false
            button.tintColor = .lightGray
            countLikes -= 1
        } else {
            isLiked = true
            button.tintColor = .systemRed
            countLikes += 1
        }
        button.setTitle(String(countLikes), for: .normal)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = bounds
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupButton()
    }
    

    

}

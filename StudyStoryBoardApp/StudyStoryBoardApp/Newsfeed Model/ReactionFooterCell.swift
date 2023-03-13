//
//  ReactionFooterCell.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 18.02.2023.
//

import UIKit

class ReactionFooterCell: UITableViewCell {
    
    @IBOutlet weak var backroundView: UIView!
    
    // like
    @IBOutlet weak var likesView: UIView!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    // comments
    @IBOutlet weak var commentsView: UIView!
    @IBOutlet weak var commentsCount: UILabel!
    
    // shares
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var shareCount: UILabel!
    
    // views
    @IBOutlet weak var viewsCount: UILabel!
    
    
    func setReactions(likes: Int, comments: Int, share: Int, views: Int) {
        likesCount.text = String(likes)
        commentsCount.text = String(comments)
        shareCount.text = String(share)
        
        if views < 1001 {
            viewsCount.text = String(views)
        } else {
            viewsCount.text = "\(views / 1000)K"
        }
    }
    
    func setup() {
        backroundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        backroundView.layer.cornerRadius = 20
        likesView.layer.cornerRadius = likesView.frame.height / 2
        commentsView.layer.cornerRadius = commentsView.frame.height / 2
        shareView.layer.cornerRadius = shareView.frame.height / 2
    }
    
    override func prepareForReuse() {
        likesCount.text = nil
        shareCount.text = nil
        commentsCount.text = nil
        viewsCount.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
}

//
//  PostTableViewCell.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 01.11.2022.
//

import UIKit
import SDWebImage

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var superView: UIView!
    
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var whenBePublic: UILabel!
    
    @IBOutlet weak var topTextConstraint: NSLayoutConstraint!
    @IBOutlet weak var textPost: UILabel!
    
    @IBOutlet weak var likeButton: UIView!
    @IBOutlet weak var commentButton: UIView!
    @IBOutlet weak var shareButton: UIView!
    @IBOutlet weak var seesPostCount: UILabel!
    
    //MARK: - Предустановка и конфигурация ячейки
    var indexPathRow = 0
    var postSelf: AnyObject?
    
    func setup() {
        
        superView.layer.cornerRadius = 20
        superView.layer.borderColor = UIColor(red: 0.902, green: 0.945, blue: 0.965, alpha: 1).cgColor
        superView.layer.borderWidth = 1
        
        imageProfile.layer.cornerRadius = imageProfile.layer.frame.size.height / 2
        likeButton.layer.cornerRadius = likeButton.layer.frame.size.height / 2
        commentButton.layer.cornerRadius = commentButton.frame.size.height / 2
        shareButton.layer.cornerRadius = shareButton.frame.size.height / 2
    }
    
    func configurate(post: AnyObject?, owner: AnyObject?) {
        
        guard let likesCount = likeButton.subviews[1] as? UILabel,
              let commentCount = commentButton.subviews[1] as? UILabel,
              let shareCount = shareButton.subviews[0] as? UILabel,
              let likeImage = likeButton.subviews[0] as? UIImageView
        else { return }
        
        if let post = post as? WallItem {
            postSelf = post
            // Заполнение поста
            whenBePublic.text = post.date.formatted(date: .abbreviated, time: .omitted)
            textPost.text = post.text
            if post.text == "" { topTextConstraint.constant = 64 } else { topTextConstraint.constant = 76 }
            likesCount.text = String(post.likes.count)
            commentCount.text = String(post.comments.count)
            shareCount.text = String(post.reposts.count)
            
            if (post.views?.count ?? 0) > 9999 {
                seesPostCount.text = String(Int(post.views!.count! / 1000)) + "K"
            } else {
                seesPostCount.text = String(post.views?.count ?? 0)
            }
            
            if !(post.likes.canLike ?? true) {
                likeImage.image = UIImage(named: "likefill")
                likeButton.layer.backgroundColor = UIColor(red: 0.99, green: 0.24, blue: 0.28, alpha: 1.00).cgColor
                likesCount.textColor = .white
            } else {
                likeImage.image = UIImage(named: "like")
                likesCount.textColor = UIColor(red: 0.00, green: 0.23, blue: 0.33, alpha: 0.3)
                likeButton.layer.backgroundColor = UIColor(red: 0.00, green: 0.23, blue: 0.33, alpha: 0.04).cgColor
            }
            
            if let group = owner as? GroupItem {
                imageProfile.sd_setImage(with: URL(string: group.avatar))
                imagePost.sd_setImage(with: URL(string: post.copyHistory?.first?.attachments.first?.photo?.sizes.last?.url ?? "")) { image, _, _, _ in
                    guard let img = image
                    else { return }
                    self.imagePost.image = self.resizeImage(image: img, targetSize: CGSize(width: self.imagePost.frame.width, height: 0))
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "loadingSuccess")))
                }
                name.text = group.name
            } else if let profile = owner as? ProfileItem {
                imageProfile.sd_setImage(with: URL(string: profile.avatar))
                imagePost.sd_setImage(with: URL(string: post.attachments?.first?.photo?.sizes.last?.url ?? "")) { image, _, _, _ in
                    guard let img = image
                    else { return }
                    self.imagePost.image = self.resizeImage(image: img, targetSize: CGSize(width: self.imagePost.frame.width, height: 0))
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "loadingSuccess")))
                }
                name.text = profile.firstName + " " + profile.lastName
            }
        } else if let post = post as? NewsFeedItem {
            postSelf = post
            // Заполнение поста
            whenBePublic.text = post.date.formatted(date: .abbreviated, time: .shortened)
            textPost.text = post.text
            if post.text == "" { topTextConstraint.constant = 64 } else { topTextConstraint.constant = 76 }
            likesCount.text = String(post.likes.count)
            commentCount.text = String(post.comments.count)
            shareCount.text = String(post.reposts.count)
            
            if (post.views.count ?? 0) > 9999 {
                seesPostCount.text = String(Int(post.views.count! / 1000)) + "K"
            } else {
                seesPostCount.text = String(post.views.count ?? 0)
            }
            
            if !(post.likes.canLike ?? true) {
                likeImage.image = UIImage(named: "likefill")
                likeButton.layer.backgroundColor = UIColor(red: 0.99, green: 0.24, blue: 0.28, alpha: 1.00).cgColor
                likesCount.textColor = .white
            } else {
                likeImage.image = UIImage(named: "like")
                likesCount.textColor = UIColor(red: 0.00, green: 0.23, blue: 0.33, alpha: 0.3)
                likeButton.layer.backgroundColor = UIColor(red: 0.00, green: 0.23, blue: 0.33, alpha: 0.04).cgColor
            }
            
            if let group = owner as? GroupItem {
                imageProfile.sd_setImage(with: URL(string: group.avatar))
                imagePost.sd_setImage(with: URL(string: post.attachments.first?.photo?.sizes.last?.url ?? "")) { image, _, _, _ in
                    guard let img = image
                    else { return }
                    self.imagePost.image = self.resizeImage(image: img, targetSize: CGSize(width: self.imagePost.frame.width, height: 0))
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "loadingSuccess")))
                }
                name.text = group.name
            } else if let profile = owner as? ProfileItem {
                imageProfile.sd_setImage(with: URL(string: profile.avatar))
                imagePost.sd_setImage(with: URL(string: post.attachments.first?.photo?.sizes.last?.url ?? "")) { image, _, _, _ in
                    guard let img = image
                    else { return }
                    self.imagePost.image = self.resizeImage(image: img, targetSize: CGSize(width: self.imagePost.frame.width, height: 0))
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "loadingSuccess")))
                }
                name.text = profile.firstName + " " + profile.lastName
            }
        }
    }
        
        //MARK: - Функция преобразования картинки в нужный размер для поста
        
        func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
            
            let size = image.size
            
            let ratio = size.height / size.width
            let wight = size.width / (size.width / targetSize.width)
            
            let newSize: CGSize = CGSize(width: wight, height: wight * ratio)
            let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage!
        }
        
        //MARK: - Переопределние ячейки
        
        func clearCell() {
            
            guard let likesCount = likeButton.subviews[1] as? UILabel,
                  let commentCount = commentButton.subviews[1] as? UILabel,
                  let shareCount = shareButton.subviews[0] as? UILabel,
                  let likeImage = likeButton.subviews[0] as? UIImageView
            else { return }
            
            imageProfile.image = nil
            name.text = nil
            whenBePublic.text = nil
            textPost.text = nil
            likesCount.text = nil
            commentCount.text = nil
            shareCount.text = nil
            likeImage.image = nil
            imagePost.image = nil
            
        }
        
        override func prepareForReuse() {
            clearCell()
        }
        
        override func awakeFromNib() {
            super.awakeFromNib()
            setup()
            likeRecogniser()
            clearCell()
        }
        
        //MARK: - Анимаци нажатия лайка
        
        func likeRecogniser() {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(addLike))
            recognizer.numberOfTapsRequired = 1
            recognizer.numberOfTouchesRequired = 1
            likeButton.addGestureRecognizer(recognizer)
        }
        
        @objc func addLike() {
            guard let imageView = likeButton.subviews[0] as? UIImageView,
                  let likesCount = likeButton.subviews[1] as? UILabel
            else { return }
            if let post = postSelf as? WallItem {
                if post.likes.canLike ?? false {
                    post.likes.canLike = false
                    ServiseAPI().postRequestLikeAndUnlike(post: post, method: .likesAdd) { count in
                        likesCount.text = count
                    }
                    UIView.animate(withDuration: 0.25, delay: 0.05, options: .showHideTransitionViews) { [weak self] in
                        guard let self = self else { return }
                        imageView.image = UIImage(named: "likefill")
                        self.likeButton.layer.backgroundColor = UIColor(red: 0.99, green: 0.24, blue: 0.28, alpha: 1.00).cgColor
                        likesCount.textColor = .white
                        self.likeButton.layoutIfNeeded()
                    }
                } else {
                    post.likes.canLike = true
                    ServiseAPI().postRequestLikeAndUnlike(post: post, method: .likesDelete) { count in
                        likesCount.text = count
                    }
                    UIView.animate(withDuration: 0.25, delay: 0.05, options: .showHideTransitionViews) { [weak self] in
                        guard let self = self else { return }
                        self.likeButton.layer.backgroundColor = UIColor(red: 0.00, green: 0.23, blue: 0.33, alpha: 0.04).cgColor
                        likesCount.textColor = UIColor(red: 0.00, green: 0.23, blue: 0.33, alpha: 0.3)
                    } completion: { _ in
                        UIView.animate(withDuration: 0.25, delay: 0, options: .transitionCrossDissolve) {
                            imageView.image = UIImage(named: "like")
                        }
                    }
                }
            } else if let post = postSelf as? NewsFeedItem {
                if post.likes.canLike ?? false {
                    post.likes.canLike = false
                    ServiseAPI().postRequestLikeAndUnlike(post: post, method: .likesAdd) { count in
                        likesCount.text = count
                    }
                    UIView.animate(withDuration: 0.25, delay: 0.05, options: .showHideTransitionViews) { [weak self] in
                        guard let self = self else { return }
                        imageView.image = UIImage(named: "likefill")
                        self.likeButton.layer.backgroundColor = UIColor(red: 0.99, green: 0.24, blue: 0.28, alpha: 1.00).cgColor
                        likesCount.textColor = .white
                        self.likeButton.layoutIfNeeded()
                    }
                } else {
                    post.likes.canLike = true
                    ServiseAPI().postRequestLikeAndUnlike(post: post, method: .likesDelete) { count in
                        likesCount.text = count
                    }
                    UIView.animate(withDuration: 0.25, delay: 0.05, options: .showHideTransitionViews) { [weak self] in
                        guard let self = self else { return }
                        self.likeButton.layer.backgroundColor = UIColor(red: 0.00, green: 0.23, blue: 0.33, alpha: 0.04).cgColor
                        likesCount.textColor = UIColor(red: 0.00, green: 0.23, blue: 0.33, alpha: 0.3)
                    } completion: { _ in
                        UIView.animate(withDuration: 0.25, delay: 0, options: .transitionCrossDissolve) {
                            imageView.image = UIImage(named: "like")
                        }
                    }
                }
            }
        }
    }



//extension UILabel {
//    func calculateMaxLines() -> Int {
//        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
//        let charSize = font.lineHeight
//        let text = (self.text ?? "") as NSString
//        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font as Any], context: nil)
//        let linesRoundedUp = Int(ceil(textSize.height/charSize))
//        return linesRoundedUp
//    }
//}

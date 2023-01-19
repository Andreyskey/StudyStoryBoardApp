//
//  PostTableViewCell.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 01.11.2022.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var superView: UIView!
    
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var whenBePublic: UILabel!
    
    @IBOutlet weak var doubleTapLikeView: UIView!
    
    @IBOutlet weak var textPost: UILabel!
    
    @IBOutlet weak var likeButton: UIView!
    @IBOutlet weak var commentButton: UIView!
    @IBOutlet weak var shareButton: UIView!
    @IBOutlet weak var seesPostCount: UILabel!

    //MARK: - Предустановка и конфигурация ячейки
    var indexPathRow = 0
    
    func setup() {
        
        superView.layer.cornerRadius = 20
        superView.layer.borderColor = UIColor(red: 0.902, green: 0.945, blue: 0.965, alpha: 1).cgColor
        superView.layer.borderWidth = 1
        
        imageProfile.layer.cornerRadius = imageProfile.layer.frame.size.height / 2
        likeButton.layer.cornerRadius = likeButton.layer.frame.size.height / 2
        commentButton.layer.cornerRadius = commentButton.frame.size.height / 2
        shareButton.layer.cornerRadius = shareButton.frame.size.height / 2
    }
    
    func configurate(post: Wall, owner: AnyObject?) {
        
        guard let likesCount = likeButton.subviews[1] as? UILabel,
              let commentCount = commentButton.subviews[1] as? UILabel,
              let shareCount = shareButton.subviews[0] as? UILabel,
              let likeImage = likeButton.subviews[0] as? UIImageView
        else { return }
        
        // Заполнение поста
        whenBePublic.text = NSDate(timeIntervalSince1970: Double(post.date)).description
        textPost.text = post.text
        likesCount.text = String(post.likes ?? 0)
        commentCount.text = String(post.comments ?? 0)
        shareCount.text = String(post.reposts ?? 0)
        seesPostCount.text = String(post.views ?? 0)
        
        
        
        
        if let group = owner as? Group {
            downloadingImage(urlImage: group.avatar, imageView: imageProfile)
            downloadingImage(urlImage: post.photosGroups, imageView: imagePost)
            name.text = group.name
        } else if let profile = owner as? Friend {
            downloadingImage(urlImage: profile.avatar, imageView: imageProfile)
            downloadingImage(urlImage: post.photosProfile, imageView: imagePost)
            name.text = profile.firstName + " " + profile.lastName
        }
        
        likeImage.image = UIImage(named: "like")
        likesCount.textColor = UIColor(red: 0.00, green: 0.23, blue: 0.33, alpha: 0.3)
        
//        if post.isLiked {
//            likeImage.image = UIImage(named: "likefill")
//            likeButton.layer.backgroundColor = UIColor(red: 0.99, green: 0.24, blue: 0.28, alpha: 1.00).cgColor
//            likesCount.textColor = .white
//        } else {
//            likeImage.image = UIImage(named: "like")
//        }
    }
        
    
    func downloadingImage(urlImage: String?, imageView: UIImageView) {
        guard let url = urlImage else { return }
        if let url = URL(string: url) {
            let _ = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    imageView.image = self.resizeImage(image: UIImage(data: data),
                                                       targetSize: CGSize(width: self.imagePost.bounds.width,
                                                                          height: 0 ))
                    
                }
            }.resume()
        }
    }
    //MARK: - Функция преобразования картинки в нужный размер для поста
    
    func resizeImage(image: UIImage?, targetSize: CGSize) -> UIImage {
        guard let image = image else { return UIImage() }
        
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
//        likeRecogniser()
        clearCell()
    }
    
    //MARK: - Анимаци нажатия лайка
    
//    func likeRecogniser() {
//        let recognizer = UITapGestureRecognizer(target: self, action: #selector(addLike))
//        recognizer.numberOfTapsRequired = 1
//        recognizer.numberOfTouchesRequired = 1
//        likeButton.addGestureRecognizer(recognizer)
//
//        let recognizerDoudleTap = UITapGestureRecognizer(target: self, action: #selector(addLike))
//        recognizerDoudleTap.numberOfTapsRequired = 2
//        doubleTapLikeView.addGestureRecognizer(recognizerDoudleTap)
//    }
    
//    @objc func addLike() {
//        guard let imageView = likeButton.subviews[0] as? UIImageView,
//              let likesCount = likeButton.subviews[1] as? UILabel
//        else { return }
//
//        if !postView.isLiked {
//            postView.countLikes += 1
//            postView.isLiked = true
//            UIView.animate(withDuration: 0.25, delay: 0.05, options: .showHideTransitionViews) { [weak self] in
//                guard let self = self else { return }
//                imageView.image = UIImage(named: "likefill")
//                self.likeButton.layer.backgroundColor = UIColor(red: 0.99, green: 0.24, blue: 0.28, alpha: 1.00).cgColor
//                likesCount.text = String(postView.countLikes)
//                likesCount.textColor = .white
//                self.likeButton.layoutIfNeeded()
//            }
//        } else {
//            postView.countLikes -= 1
//            postView.isLiked = false
//            UIView.animate(withDuration: 0.25, delay: 0.05, options: .showHideTransitionViews) { [weak self] in
//                guard let self = self else { return }
//                self.likeButton.layer.backgroundColor = UIColor(red: 0.00, green: 0.23, blue: 0.33, alpha: 0.04).cgColor
//                likesCount.text = String(postView.countLikes)
//                likesCount.textColor = UIColor(red: 0.00, green: 0.23, blue: 0.33, alpha: 0.3)
//            } completion: { _ in
//                UIView.animate(withDuration: 0.25, delay: 0, options: .transitionCrossDissolve) {
//                    imageView.image = UIImage(named: "like")
//                }
//            }
//        }
//
//    }
    
    
}




extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font as Any], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}

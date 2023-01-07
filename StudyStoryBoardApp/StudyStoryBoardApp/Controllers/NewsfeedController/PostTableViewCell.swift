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
    
    var postData: Post?
    
    func setup() {
        
        superView.layer.cornerRadius = 20
        superView.layer.borderColor = UIColor(red: 0.902, green: 0.945, blue: 0.965, alpha: 1).cgColor
        superView.layer.borderWidth = 1
        
        imageProfile.layer.cornerRadius = imageProfile.layer.frame.size.height / 2
        likeButton.layer.cornerRadius = likeButton.layer.frame.size.height / 2
        commentButton.layer.cornerRadius = commentButton.frame.size.height / 2
        shareButton.layer.cornerRadius = shareButton.frame.size.height / 2
    }
    
    func configurate(post: Post, indexPath: IndexPath) {
        
        guard let likesCount = likeButton.subviews[1] as? UILabel,
              let commentCount = commentButton.subviews[1] as? UILabel,
              let shareCount = shareButton.subviews[0] as? UILabel,
              let likeImage = likeButton.subviews[0] as? UIImageView
        else { return }
        
        indexPathRow = indexPath.row
                          
        postData = post
        
        name.text = post.name
        imageProfile.image = post.imageProfile
        whenBePublic.text = post.timePost
        textPost.text = post.textPost
        likesCount.text = String(post.countLikes)
        commentCount.text = String(post.countComment)
        shareCount.text = String(post.countShare)
        seesPostCount.text = post.seesCount
        
        if post.ImagePost[0] != nil {
            let img = UIImage(named: post.ImagePost[0] ?? "")!
            imagePost.image = resizeImage(image: img, targetSize: CGSize(width: imagePost.bounds.width, height: 0 ))
        }
        
        
        if post.isLiked {
            likeImage.image = UIImage(named: "likefill")
            likeButton.layer.backgroundColor = UIColor(red: 0.99, green: 0.24, blue: 0.28, alpha: 1.00).cgColor
            likesCount.textColor = .white
        } else {
            likeImage.image = UIImage(named: "like")
            likeButton.layer.backgroundColor = UIColor(red: 0.00, green: 0.23, blue: 0.33, alpha: 0.04).cgColor
            likesCount.textColor = UIColor(red: 0.00, green: 0.23, blue: 0.33, alpha: 0.3)
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
        
        let recognizerDoudleTap = UITapGestureRecognizer(target: self, action: #selector(addLike))
        recognizerDoudleTap.numberOfTapsRequired = 2
        doubleTapLikeView.addGestureRecognizer(recognizerDoudleTap)
    }
    
    @objc func addLike() {
        guard let imageView = likeButton.subviews[0] as? UIImageView,
              let likesCount = likeButton.subviews[1] as? UILabel
        else { return }
        
        var postView = postOne[indexPathRow]
        
        if !postView.isLiked {
            postView.countLikes += 1
            postView.isLiked = true
            UIView.animate(withDuration: 0.25, delay: 0.05, options: .showHideTransitionViews) { [weak self] in
                guard let self = self else { return }
                imageView.image = UIImage(named: "likefill")
                self.likeButton.layer.backgroundColor = UIColor(red: 0.99, green: 0.24, blue: 0.28, alpha: 1.00).cgColor
                likesCount.text = String(postView.countLikes)
                likesCount.textColor = .white
                self.likeButton.layoutIfNeeded()
            }
        } else {
            postView.countLikes -= 1
            postView.isLiked = false
            UIView.animate(withDuration: 0.25, delay: 0.05, options: .showHideTransitionViews) { [weak self] in
                guard let self = self else { return }
                self.likeButton.layer.backgroundColor = UIColor(red: 0.00, green: 0.23, blue: 0.33, alpha: 0.04).cgColor
                likesCount.text = String(postView.countLikes)
                likesCount.textColor = UIColor(red: 0.00, green: 0.23, blue: 0.33, alpha: 0.3)
            } completion: { _ in
                UIView.animate(withDuration: 0.25, delay: 0, options: .transitionCrossDissolve) {
                    imageView.image = UIImage(named: "like")
                }
            }
        }
        postOne[indexPathRow] = postView
        
    }
    
    
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

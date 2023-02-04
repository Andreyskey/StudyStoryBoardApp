//
//  ShowPhotoViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 08.01.2023.
//

import UIKit
import RealmSwift

class ShowPhotoViewController: UIViewController {

    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var likeView: UIView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let realm = try! Realm()
    var images = [PhotoItem]()
    var userID = 0
    var startIndexPathItem = 0
    var indexPathRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        likeRecogniser()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "ShowImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "showPhoto")
        
        shareView.layer.cornerRadius = shareView.layer.frame.size.height / 2
        commentView.layer.cornerRadius = commentView.layer.frame.size.height / 2
        likeView.layer.cornerRadius = likeView.layer.frame.size.height / 2
    }
    
    func setValueDataPhoto(indexPathRow: Int) {
        guard let likesCount = likeView.subviews[1] as? UILabel,
              let shareCount = shareView.subviews[0] as? UILabel,
              let commentsCount = commentView.subviews[1] as? UILabel
        else { return }
        
        likesCount.text = String(images[indexPathRow].likes?.count ?? 0)
        shareCount.text = String(images[indexPathRow].reposts)
        commentsCount.text = String(images[indexPathRow].comments)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToIndex(index: startIndexPathItem)
    }
}

extension ShowPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "showPhoto", for: indexPath) as? ShowImageCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configurate(imageUrl: images[indexPath.row].sizes.last?.url)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        navigationBar.topItem?.title = "Фото \(indexPath.row + 1) из \(images.count)"
        setValueDataPhoto(indexPathRow: indexPath.row)
        indexPathRow = indexPath.row
        
        guard let imageView = likeView.subviews[0] as? UIImageView,
              let likesCount = likeView.subviews[1] as? UILabel
        else { return }
        
        if images[indexPath.row].likes?.userLikes ?? true {
            likeView.layer.backgroundColor = UIColor(red: 0.99, green: 0.24, blue: 0.28, alpha: 1.00).cgColor
            imageView.image = UIImage(named: "likefill")
            likesCount.textColor = .white
        } else {
            self.likeView.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
            imageView.image = UIImage(named: "icons8-heart 1")
            likesCount.textColor = .black
        }
    }
    
    func scrollToIndex(index: Int) {
//        let indexPath = NSIndexPath(item: index, section: 0)
//        collectionView.scrollToItem(at: indexPath as IndexPath, at: .right, animated: false)
        let rect = collectionView.layoutAttributesForItem(at: IndexPath(row: index, section: 0))?.frame
        collectionView.scrollRectToVisible(rect!, animated: true)
    }
    //MARK: - LikeAction
    
    func likeRecogniser() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(addLike))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        likeView.addGestureRecognizer(recognizer)
    }
    
    @objc func addLike() {
        guard let imageView = likeView.subviews[0] as? UIImageView,
              let likesCount = likeView.subviews[1] as? UILabel
        else { return }
        
        let photo = realm.object(ofType: ProfileItem.self, forPrimaryKey: userID)?.photos[indexPathRow]
        
        if !(photo?.likes?.userLikes ?? false) {
            try! realm.write {
                photo?.likes?.userLikes = true
                photo?.likes?.count += 1
            }
            ServiseAPI().postRequestLikeAndUnlike(post: photo, method: .likesAdd) { count in
                likesCount.text = String(count)
            }
            UIView.animate(withDuration: 0.25, delay: 0.05, options: .showHideTransitionViews) { [weak self] in
                guard let self = self else { return }
                imageView.image = UIImage(named: "likefill")
                likesCount.textColor = .white
                self.likeView.layer.backgroundColor = UIColor(red: 0.99, green: 0.24, blue: 0.28, alpha: 1.00).cgColor
                self.likeView.layoutIfNeeded()
            }
        } else {
            try! realm.write {
                photo?.likes?.userLikes = false
                photo?.likes?.count -= 1
            }
            ServiseAPI().postRequestLikeAndUnlike(post: photo, method: .likesDelete) { count in
                likesCount.text = String(count)
            }
            UIView.animate(withDuration: 0.25, delay: 0.05, options: .showHideTransitionViews) { [weak self] in
                guard let self = self else { return }
                self.likeView.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
                likesCount.textColor = .black
            }
            UIView.animate(withDuration: 0.25, delay: 0, options: .transitionCrossDissolve) {
                imageView.image = UIImage(named: "icons8-heart 1")
            }
        }
    }
}


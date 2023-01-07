//
//  ShowPhotoViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 08.01.2023.
//

import UIKit

class ShowPhotoViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var likeView: UIView!
    @IBOutlet weak var commView: UIView!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        likeView.layer.cornerRadius = likeView.layer.frame.size.height / 2
        commView.layer.cornerRadius = commView.layer.frame.size.height / 2
        shareView.layer.cornerRadius = shareView.layer.frame.size.height / 2
        
        collectionView.register(UINib(nibName: "ShowImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "showPhoto")
        
    }
    
    
    
}

extension ShowPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "showPhoto", for: indexPath) as? ShowImageCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configurate(img: images[indexPath.row])
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        navigationBar.topItem?.title = "Фото \(indexPath.row + 1) из \(images.count)"
    }
    
}

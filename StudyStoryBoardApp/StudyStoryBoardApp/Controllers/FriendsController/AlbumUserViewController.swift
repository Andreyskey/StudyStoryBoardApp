//
//  AlbumUserViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 14.10.2022.
//

import UIKit

class AlbumUserViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
//    {
//        didSet {
//            collectionView.delegate = self
//            collectionView.dataSource = self
//        }
//    }
    
//    var friend: Friend?
//
//    let PhotoCollectionViewControllerIdentifier = "PhotoCollectionViewControllerIdentifier"
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: PhotoCollectionViewControllerIdentifier)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard segue.identifier == "showImages" else { return }
//        guard let destination = segue.destination as? ShowPhotoViewController
//        else { return }
//        destination.images = friend?.albumImages ?? [""]
//    }
//
//    @IBAction func unwindToAlbum(_ unwindSegue: UIStoryboardSegue) {
//    }
//}
//
//extension AlbumUserViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return friend?.albumImages.count ?? 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewControllerIdentifier, for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
//
//        guard let friend = friend else { return cell }
//
//        cell.configCell(image: UIImage(named: friend.albumImages[indexPath.row]))
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//
//
//        performSegue(withIdentifier: "showImages", sender: nil)
//    }
    
}

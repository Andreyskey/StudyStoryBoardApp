//
//  AlbumUserViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 14.10.2022.
//

import UIKit

class AlbumUserViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    var name = ""
    
    let PhotoCollectionViewControllerIdentifier = "PhotoCollectionViewControllerIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: PhotoCollectionViewControllerIdentifier)
    }
    
    

}

extension AlbumUserViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewControllerIdentifier, for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configCell(image: UIImage(named: name))
        
        return cell
    }
    
}

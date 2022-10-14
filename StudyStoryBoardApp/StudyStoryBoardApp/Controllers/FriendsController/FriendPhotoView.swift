//
//  FriendPhotoView.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 14.10.2022.
//

import UIKit

class FriendPhotoView: UIViewController {
    
    var name = ""
    
    let PhotoCollectionViewControllerIdentifier = "PhotoCollectionViewControllerIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    

}

extension FriendPhotoView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell =
    }
    
    
}

//
//  AlbumUserViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 14.10.2022.
//

import UIKit
import Alamofire

class AlbumUserViewController: UIViewController {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textIfAlbumIsEmpty: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    var photos = [PhotoItem]()
    var userId: ProfileItem?
    let PhotoCollectionViewControllerIdentifier = "PhotoCollectionViewControllerIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: PhotoCollectionViewControllerIdentifier)
        loadingIndicator.startAnimating()
        textIfAlbumIsEmpty.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let id = userId?.id else { return }
        let paramsPhoto: Parameters = [
            "access_token" : Session.share.token,
            "owner_id" : String(id),
            "album_id" : "profile",
            "extended" : "1",
            "rev" : "0",
            "photo_sizes" : "1",
            "v" : "5.131"
        ]
        ServiseAPI().getRequestPhotos(method: .photosGet, parammeters: paramsPhoto) { array in
            guard let photosUser = array else { return }
            self.photos = photosUser
            self.collectionView.reloadData()
            if photosUser.isEmpty { self.textIfAlbumIsEmpty.isHidden = false }
            self.loadingIndicator.stopAnimating()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showImages" else { return }
        guard let destination = segue.destination as? ShowPhotoViewController
        else { return }
        destination.images = photos
        destination.startIndexPathItem = collectionView.indexPathsForSelectedItems![0].item
        
    }

    @IBAction func unwindToAlbum(_ unwindSegue: UIStoryboardSegue) {
        
    }
}

extension AlbumUserViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewControllerIdentifier, for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }

        cell.configCell(imageUrl: photos[indexPath.row].sizes.last?.url)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadingIndicator.stopAnimating()
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showImages", sender: nil)
    }
    
}

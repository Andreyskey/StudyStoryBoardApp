//
//  ShowImageCollectionViewCell.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 08.01.2023.
//

import UIKit

class ShowImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    
    func configurate(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            let _ = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async {
                    self.image.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    
    func clearCell() {
        image.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clearCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
    }

}

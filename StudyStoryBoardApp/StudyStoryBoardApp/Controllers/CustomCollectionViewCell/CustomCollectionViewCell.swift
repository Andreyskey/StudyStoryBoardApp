//
//  CustomCollectionViewCell.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 14.10.2022.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var img: UIImageView!
    
    func configCell(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            let _ = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async {
                    self.img.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    
    func clearCell() {
        img.image = nil
    }
    
    override func prepareForReuse() {
        clearCell()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}

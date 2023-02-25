//
//  ImagesPostCell.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 18.02.2023.
//

import UIKit
import SDWebImage

class ImagesPostCell: UITableViewCell {

    @IBOutlet weak var imagesPost: UIImageView!
    
    let nofityLoadingData = Notification.Name("loadingSuccess")
    
    func addImages(size: SizePhoto?) {
        guard let size = size else { return }
        let url = URL(string: size.url)
        
        imagesPost.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder")) { img, _, _, _ in
            if let img = img {
                self.imagesPost.image = self.resizeImage(image: img, targetSize: CGSize(width: self.imagesPost.frame.size.width, height: 0))
                NotificationCenter.default.post(Notification(name: self.nofityLoadingData))
            }
        }
    }
    
    override func prepareForReuse() {
        imagesPost.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imagesPost.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
    }
    
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        
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
}

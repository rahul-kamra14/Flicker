//
//  ImageCollectionViewCell.swift
//  FlickerApp
//
//  Created by Rahul Kamra on 30/08/20.
//  Copyright © 2020 Rahul Kamra. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func configure(model: PhotosModel?){
        if let model = model {
            imageView.image = UIImage(named: "placeholder")
            guard let url =  model.flickrImageURL() else {
                return
            }
            ImageManager.sharedInstance.downloadImageFromURL(url) { [weak self] (success, image, urlString) in
                guard let strongSelf = self else { return }
                if success && image != nil && urlString == model.flickrImageURL() {
                    DispatchQueue.main.async {
                        strongSelf.imageView.image = image
                    }
                }
            }
        }
    }
}


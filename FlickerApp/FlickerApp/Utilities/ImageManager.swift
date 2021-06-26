//
//  ImageManager.swift
//  FlickerApp
//
//  Created by Rahul Kamra on 30/08/20.
//  Copyright © 2020 Rahul Kamra. All rights reserved.
//

import Foundation
import UIKit

class ImageManager: NSObject {
    static let sharedInstance = ImageManager()
    var imageCache = NSCache<NSString, UIImage>()

    func cacheImage(_ image: UIImage, forURL url: String) {
        imageCache.setObject(image, forKey: url as NSString)
    }

    func cachedImageForURL(_ url: String) -> UIImage? {
        return imageCache.object(forKey: url as NSString)
    }

    func downloadImageFromURL(_ urlString: String, completion: ((_ success: Bool, _ image: UIImage?,_ urlStr: String) -> Void)?) {
        if let cachedImage = cachedImageForURL(urlString) {
            completion?(true, cachedImage, urlString)
        } else if let url = URL(string: urlString) { // download from URL asynchronously
            let session = URLSession.shared
            let downloadTask = session.downloadTask(with: url, completionHandler: { [weak self] (retrievedURL, _, error) -> Void in
                guard let strongSelf = self else { return }
                var found = false
                guard let retrievedUrl = retrievedURL, error == nil else {
                    print("Error downloading image \(url.absoluteString): \(error!.localizedDescription)")
                    return
                }
                    if let data = try? Data(contentsOf: retrievedUrl) {
                        if let image = UIImage(data: data) {
                            found = true
                            strongSelf.cacheImage(image, forURL: url.absoluteString)
                            completion?(true, image, urlString)
                        }
                }
                if !found {
                    completion?(false, nil, urlString)
                }
            })
            downloadTask.resume()
        } else {
            completion?(false, nil, urlString)
        }
    }

}

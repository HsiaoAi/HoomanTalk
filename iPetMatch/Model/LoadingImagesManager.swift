//
//  LoadingImagesManager.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 09/01/2018.
//  Copyright © 2018 Hsiao Ai LEE. All rights reserved.
//

class LoadingImagesManager {

    let imageCache = NSCache<NSString, UIImage>()

    func downloadAndCacheImage(urlString: String, imageView: UIImageView, activityIndicatorView: NVActivityIndicatorView?) {
        if let cachedImage = self.imageCache.object(forKey: urlString as NSString) {
            imageView.image = cachedImage

        } else {

            activityIndicatorView?.startAnimating()
            Manager.shared.loadImage(with: Request(url: URL(string: urlString)!),
                                     into: imageView) { response, _ in
                SVProgressHUD.dismiss()
                activityIndicatorView?.stopAnimating()
                let image = response.value
                imageView.image = image
                activityIndicatorView?.stopAnimating()
                self.imageCache.setObject(image!, forKey: urlString as NSString)
            }

        }
    }
}

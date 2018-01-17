//
//  LoadingImagesManager.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 09/01/2018.
//  Copyright © 2018 Hsiao Ai LEE. All rights reserved.
//

class LoadingImagesManager {

    let imageCache = NSCache<NSString, UIImage>()

    func downloadAndCacheImage(urlString: String, imageView: UIImageView,
                               activityIndicatorView: NVActivityIndicatorView?, placeholderImage: UIImage?) {
        imageView.tintColor = .gray
        activityIndicatorView?.startAnimating()
        imageView.sd_setImage(with: URL(string: urlString), placeholderImage: nil) { (_, _, _, _) in
            activityIndicatorView?.stopAnimating()
        }
    }
}

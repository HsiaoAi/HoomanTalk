//
//  LikeMeCollectionViewCell.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 29/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class LikeMeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var userImageView: UIImageView!

   @IBOutlet weak var userInfoLabel: UILabel!

   @IBOutlet weak var likeButton: WCLShineButton!

    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    // @IBOutlet weak var likeButtonBorderView: LGButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        userImageView.clipsToBounds = true

       setupLikeButton()

    }

    func setupLikeButton() {

        var likeButtonParam = WCLShineParams()

        likeButtonParam.enableFlashing = true

        likeButtonParam.animDuration = 1

        likeButton.params = likeButtonParam

    }

}

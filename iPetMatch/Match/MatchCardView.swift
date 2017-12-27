//
//  MatchCardView.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 27/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class MatchCardView: UIView {

    @IBOutlet weak var userImageView: UIImageView!

    @IBOutlet weak var petCollectionView: UICollectionView!

    @IBOutlet weak var infoView: UIView!

    @IBOutlet weak var userInfo: UILabel!

    @IBOutlet weak var likeButton: WCLShineButton!

    override init(frame: CGRect) {

        super.init(frame: frame)

    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {

        setupLikeButton()

    }

    func setupLikeButton() {

        var likeButtonParam = WCLShineParams()

        likeButtonParam.enableFlashing = true

        likeButtonParam.animDuration = 1

        likeButton.params = likeButtonParam

    }

}

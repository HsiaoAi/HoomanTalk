//
//  PetsTableViewCell.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 03/01/2018.
//  Copyright © 2018 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class PetsTableViewCell: UITableViewCell {

    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var petNameLabel: UILabel!
    let loadingImagesManager = LoadingImagesManager()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none

    }

    func set(content pet: Pet) {

        let petType = (pet.petType == .dog) ? "🐶": "🐱"
        let imagePlaceholder: UIImage = (pet.petType == .dog) ? #imageLiteral(resourceName: "dogPerson") : #imageLiteral(resourceName: "catPerson")
        petNameLabel.text = pet.name! + petType
        petImageView.image = nil
        let imageURL = pet.imageURL!
        loadingImagesManager.downloadAndCacheImage(urlString: imageURL, imageView: petImageView, activityIndicatorView: nil, placeholderImage: imagePlaceholder)
        petImageView?.contentMode = .scaleAspectFill

    }

}

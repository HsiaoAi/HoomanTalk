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

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func set(content pet: Pet) {

        let petType = (pet.petType == .dog) ? "🐶": "🐱"
        petNameLabel.text = pet.name! + petType
        petImageView.image = nil
        let imageAdress = pet.imageURL
        if let imageURL = URL(string: imageAdress!) {
            UserManager.setUserProfileImage(with: imageURL,
                                            into: petImageView,
                                            activityIndicatorView: nil)
        }

    }

}

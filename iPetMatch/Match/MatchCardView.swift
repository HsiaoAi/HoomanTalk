//
//  MatchCardView.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 27/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class MatchCardView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pets.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetsCell", for: indexPath) as? PetsCell else { return PetsCell() }

        if self.pets.count > indexPath.row {

            let pet = self.pets[indexPath.row]
            let imageAdress = pet.imageURL
            if let imageURL = URL(string: imageAdress!) {
                UserManager.setUserProfileImage(with: imageURL, into: cell.petImageView, activityIndicatorView: nil)
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let borderLength = self.petCollectionView.bounds.height
        return CGSize(width: borderLength, height: borderLength)
    }

    @IBOutlet weak var matchCardView: UIImageView!

    @IBOutlet weak var userImageViewLayer: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!

    @IBOutlet weak var backgroundUserImage: UIImageView!

    @IBOutlet weak var petCollectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var petTypeLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var likeButton: WCLShineButton!

    @IBOutlet weak var likeButtonBorderView: LGButton!

    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    var pets = [Pet]()

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

        likeButtonParam.animDuration = 0.5

        likeButton.params = likeButtonParam

    }

    func setupPetsCollectionView(pets: [Pet]) {
        petCollectionView.delegate = self
        petCollectionView.dataSource = self
        self.pets = pets
        self.petCollectionView.reloadData()
        let nib = UINib(nibName: "PetsCell", bundle: nil)
        self.petCollectionView.register(nib, forCellWithReuseIdentifier: "PetsCell")
    }

}

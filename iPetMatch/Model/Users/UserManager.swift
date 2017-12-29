//
//  UserManager.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 21/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import Foundation

class UserManager {

    static let instance = UserManager()

    var currentUser: IPetUser?

    func getCurrentUserInfo(_ user: User) {

        Database.database().reference().child(FirebaseSchema.users.rawValue).child(user.uid).observeSingleEvent(
        of: .value) {[weak self] snapShot in

            guard let userDic = snapShot.value as? [String: Any] else {

                return
            }

            guard
                let name = userDic[IPetUser.Schema.name] as? String,
                let email = userDic[IPetUser.Schema.loginEmail] as? String,
                let imageURL = userDic[IPetUser.Schema.imageURL] as? String,
                let callingID = userDic[IPetUser.Schema.callingID] as? Int,
                let yearOfBirth = userDic[IPetUser.Schema.yearOfBirth] as? Int,
                let gender = userDic[IPetUser.Schema.gender] as? String,
                let petPersionType = userDic[IPetUser.Schema.petPersonType] as? String else {

                    return

            }

            UserManager.instance.currentUser = IPetUser(id: userDic.keys.first!, loginEmail: email, name: name, petPersonType: PetPersonType(rawValue: petPersionType)!, gender: Gender(rawValue: gender)!, yearOfBirth: yearOfBirth, imageURL: imageURL, callingID: UInt(callingID))

        }

    }

    static func setUserProfileImage(with imageURL: URL, into imageView: UIImageView, activityIndicatorView: NVActivityIndicatorView) {

        activityIndicatorView.startAnimating()
        Manager.shared.loadImage(with: Request(url: imageURL), into: imageView) { response, _ in
            imageView.image = response.value
            activityIndicatorView.stopAnimating()
        }

    }

}

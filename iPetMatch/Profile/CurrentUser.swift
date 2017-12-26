//
//  CurrentUser.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 14/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

struct CurrentUser {

    let loginEmail: String

    let password: String

    let firebaseUid: String

    let name: String

    var petPersonType: PetPersonType

    let gender: Gender

    let yearOfBirth: Int

    let imageURL: String

    let callingID: String

}

extension CurrentUser {

    var userImage: UIImage? {

        return UIImage()

    }

}

enum Gender: String {

    case male, female

}

enum PetPersonType {

    case dog, cat, both, none

}

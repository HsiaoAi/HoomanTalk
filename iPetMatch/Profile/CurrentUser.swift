//
//  CurrentUser.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 14/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

struct CurrentUser {

     struct Schema {

        public static let loginEmail = "loginEmail"

        public static let firebaseUid = "firebaseUid"

        public static let name = "name"

        public static let petPersonType = "petPersonType"

        public static let gender = "gender"

        public static let yearOfBirth = "yearOfBirth"

        public static let imageURL = "imageURL"

        public static let callingID = "callingID"

    }

    let loginEmail: String

    let firebaseUid: String

    let name: String

    var petPersonType: PetPersonType

    let gender: Gender

    let yearOfBirth: Int

    let imageURL: String

    let callingID: UInt

}

extension CurrentUser {

    var userImage: UIImage? {

        return UIImage()

    }

}

enum Gender: String {

    case male, female

}

enum PetPersonType: String {

    case dog, cat, both, none

}

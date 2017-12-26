//
//  User.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 14/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

struct User {

    let loginEmail: String

    let password: String

    let name: String

    var petPersonType: PetPersonType

    let gender: Gender

    let yearOfBirth: Int

    let imageURL: String

}

extension User {

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

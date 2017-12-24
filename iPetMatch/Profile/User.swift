//
//  User.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 14/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

struct User {

    let firebaseLoginID: String

    let firbasePassword: String

    let email: String

    var QBLoginID: String {

        return firebaseLoginID
    }

    let QBPassword: String

    let name: String

    var petPersonType: PetPersonType

}

extension User {

    // var imageUrl: String?

}

enum PetPersonType {

    case dog, cat, both, none

}

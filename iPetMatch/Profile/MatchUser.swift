//
//  MatchUser.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 28/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import Foundation

struct MatchUser {

    struct Schema {

        public static let name = "name"

        public static let petPersonType = "petPersonType"

        public static let gender = "gender"

        public static let yearOfBirth = "yearOfBirth"

        public static let imageURL = "imageURL"

        public static let callingID = "callingID"

    }

    let name: String

    var petPersonType: PetPersonType

    let gender: Gender

    let yearOfBirth: Int

    let imageURL: String?

    let callingID: UInt

}

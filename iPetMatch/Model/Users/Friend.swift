//
//  Friend.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 31/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import Foundation

class Friend {
    struct Schema {

        public static let id = "id"

        public static let loginEmail = "loginEmail"

        public static let name = "name"

        public static let petPersonType = "petPersonType"

        public static let gender = "gender"

        public static let yearOfBirth = "yearOfBirth"

        public static let imageURL = "imageURL"

        public static let callingID = "callingID"

        public static let lastCallTime = "lastCallTime"

        public static let lastCallType = "lastCallType"

    }

    let id: String?
    let loginEmail: String?
    let name: String?
    var petPersonType: PetPersonType?
    let gender: Gender?
    let yearOfBirth: Int?

    let imageURL: String?

    let callingID: UInt?

    var lastCallTime: String?

    var lastCallType: String?

    init(dictionary: [String: Any]) {

        if let petPersonTypeString = dictionary[Friend.Schema.petPersonType] as? String {
            self.petPersonType = PetPersonType(rawValue: petPersonTypeString)
        } else {
            self.petPersonType = nil
        }

        if let genderString = dictionary[Friend.Schema.gender] as? String {
            self.gender = Gender(rawValue: genderString)
        } else {
            self.gender = nil
        }

        self.id = dictionary[Friend.Schema.id] as? String
        self.loginEmail = dictionary[Friend.Schema.loginEmail] as? String
        self.name = dictionary[Friend.Schema.name] as? String
        self.yearOfBirth = dictionary[Friend.Schema.yearOfBirth] as? Int
        self.imageURL = dictionary[Friend.Schema.imageURL] as? String
        self.callingID = dictionary[Friend.Schema.callingID] as? UInt
        self.lastCallTime = dictionary[Friend.Schema.lastCallTime] as? String
        self.lastCallType = dictionary[Friend.Schema.lastCallType] as? String

    }

}

//
//  CurrentUser.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 28/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

struct IPetUser: Equatable {
    static func == (lhs: IPetUser, rhs: IPetUser) -> Bool {
        return (lhs.id == rhs.id)
    }

    struct Schema {

        public static let id = "id"

        public static let loginEmail = "loginEmail"

        public static let name = "name"

        public static let petPersonType = "petPersonType"

        public static let gender = "gender"

        public static let yearOfBirth = "yearOfBirth"

        public static let imageURL = "imageURL"

        public static let callingID = "callingID"

    }

    let id: String

    let loginEmail: String

    let name: String

    var petPersonType: PetPersonType

    let gender: Gender

    let yearOfBirth: Int

    let imageURL: String?

    let callingID: UInt

//    init(dictionary: [String: Any]) {
//
//        let petPersonType = PetPersonType(rawValue: String(describing: dictionary[IPetUser.Schema.petPersonType]))!
//        let gender = Gender(rawValue: String(describing: dictionary[IPetUser.Schema.gender]))!
//
//
//        self.id = dictionary[IPetUser.Schema.id] as? String
//        self.loginEmail = dictionary[IPetUser.Schema.loginEmail] as? String
//        self.name = dictionary[IPetUser.Schema.name] as? String
//        self.petPersonType = petPersonType
//        self.gender = gender
//        self.yearOfBirth = dictionary[IPetUser.Schema.yearOfBirth] as? Int
//        self.imageURL = dictionary[IPetUser.Schema.imageURL] as? String
//        self.callingID = dictionary[IPetUser.Schema.callingID] as? UInt
//
//    }

}

extension IPetUser {

    var userImage: UIImage? {

        return UIImage()

    }

}

enum Gender: String {

    case male, female

}

enum PetPersonType: String {

    case dog, cat, both

}

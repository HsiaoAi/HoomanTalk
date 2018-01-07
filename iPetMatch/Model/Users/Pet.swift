//
//  Pet.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 02/01/2018.
//  Copyright © 2018 Hsiao Ai LEE. All rights reserved.
//

class Pet {

    struct Schema {

        static let breeds = "breeds"
        static let name = "name"
        static let imageURL = "imageURL"
        static let sex = "sex"
        static let petType = "petType"
        static let birth = "birth"
        static let size = "size"
        static let ownerId = "ownerId"
        static let about = "about"
        static let id = "id"

    }

    let name: String?
    let imageURL: String?
    let sex: Gender?
    let petType: PetType?
    let birth: String?
    let size: Size?
    let breeds: String?
    let ownerId: String?
    let about: String?
    let id: String?

    init(dictionary: [String: Any]) {

        self.name = dictionary[Pet.Schema.name] as? String
        self.imageURL = dictionary[Pet.Schema.imageURL] as? String
        let sexRawValue = dictionary[Pet.Schema.sex] as? String ?? ""
        self.sex = Gender(rawValue: sexRawValue)!
        let petTypeRawValue = dictionary[Pet.Schema.petType] as? String ?? ""
        self.petType = PetType(rawValue: petTypeRawValue)!
        self.birth = dictionary[Pet.Schema.birth] as? String
        let sizeRawValue = dictionary[Pet.Schema.size] as? String ?? ""
        self.size = Size(rawValue: sizeRawValue)
        self.breeds = dictionary[Pet.Schema.breeds] as? String
        self.ownerId = dictionary[Pet.Schema.ownerId] as? String
        self.about = dictionary[Pet.Schema.about] as? String
        self.id = dictionary[Pet.Schema.id] as? String

    }

}

enum PetType: String {

    case cat, dog
}

enum Size: String {

    case extralSmall = "Extra Small: 1 - 4.5 Kg"
    case small =  "Small: 5 - 11.5 Kg"
    case medium =  "Medium : 12 - 18 Kg"
    case large = "Large: 18 - 32 Kg"
    case extraLarge = "Extra Large: 32 - 45 Kg"

}

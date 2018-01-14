//
//  UserPreference.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 19/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

struct UserPreference {

    static var shared = UserPreference()
    
    class Schema {
        static let petTypePreference = "petTypePreference"
        static let genderPreference = "genderPreference"
        static let maxAge = "maxAge"
        static let minAge = "minAge"
    }

    var petTypePreference: PetPersonType = .both
    var genderPreference: GenderPreference = .both
    var maxAge: Int = 55
    var minAge: Int = 18
    
    init() {
        
    }
    
    init(json: [String: Any]) {
        guard let petTypePreference = json[UserPreference.Schema.petTypePreference] as? String,
            let genderPreference = json[UserPreference.Schema.genderPreference] as? String,
            let maxAge = json[UserPreference.Schema.maxAge] as? Int,
            let minAge = json[UserPreference.Schema.minAge] as? Int else { return }
        
        self.petTypePreference = PetPersonType(rawValue: petTypePreference)!
        self.genderPreference = GenderPreference(rawValue: genderPreference)!
        self.maxAge = maxAge
        self.minAge = minAge
    }
}

enum GenderPreference: String {
    case male, female, both
}


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

    var currentUser: CurrentUser?
    
    func getCurrentUserInfo(_ user :User) {
        
        Database.database().reference().child(FirebaseSchema.users.rawValue).child(user.uid).observeSingleEvent(
        of: .value) {
            
            snapShot in
            
            guard let userDic = snapShot.value as? [String: Any] else {
                
                return
            }
            
            guard
                let name = userDic[CurrentUser.Schema.name] as? String,
                let email = userDic[CurrentUser.Schema.loginEmail] as? String,
                let imageURL = userDic[CurrentUser.Schema.imageURL] as? String,
                let callingID = userDic[CurrentUser.Schema.callingID] as? Int,
                let yearOfBirth = userDic[CurrentUser.Schema.yearOfBirth] as? Int,
                let gender = userDic[CurrentUser.Schema.gender] as? String,
                let petPersionType = userDic[CurrentUser.Schema.petPersonType] as? String else {
                    
                    return
                    
            }
            
            UserManager.instance.currentUser = CurrentUser(loginEmail: email, name: name, petPersonType: PetPersonType(rawValue: petPersionType)!, gender: Gender(rawValue: gender)!, yearOfBirth: yearOfBirth, imageURL: imageURL, callingID: UInt(callingID))
            
        }
        
    }

}

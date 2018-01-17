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

    var currentUser: IPetUser?

    func upDateCurrentUser(_ user: User) {

        Database.database().reference().child(FirebaseSchema.users.rawValue).child(user.uid).observeSingleEvent(
        of: .value) {[weak self] snapShot in

            guard let userDic = snapShot.value as? [String: Any] else {

                return
            }

            guard
                let name = userDic[IPetUser.Schema.name] as? String,
                let email = userDic[IPetUser.Schema.loginEmail] as? String,
                let imageURL = userDic[IPetUser.Schema.imageURL] as? String,
                let callingID = userDic[IPetUser.Schema.callingID] as? Int,
                let yearOfBirth = userDic[IPetUser.Schema.yearOfBirth] as? Int,
                let gender = userDic[IPetUser.Schema.gender] as? String,
                let petPersionType = userDic[IPetUser.Schema.petPersonType] as? String else {

                    return

            }

            let user = IPetUser(id: snapShot.key, loginEmail: email, name: name, petPersonType: PetPersonType(rawValue: petPersionType)!, gender: Gender(rawValue: gender)!, yearOfBirth: yearOfBirth, imageURL: imageURL, callingID: UInt(callingID))
            UserManager.instance.currentUser = user
            RingtonePlayer.shared.ringtoneName = (user.petPersonType == .dog) ? RingtoneName.dog : RingtoneName.mewo

        }

    }

    static func registerForRemoteNotification() {

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })

        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()

    }

}

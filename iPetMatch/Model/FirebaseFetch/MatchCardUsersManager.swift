//
//  MatchCardUsersManager.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 28/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import Foundation

protocol MatchCardUsersManagerProtocol: class {

    func didObserveMatchCardUsers(_ matchCardUsers: [IPetUser])

    func didobserveLikesSentByCurrentUser(manager: MatchCardUsersManager, usersIdLikedByCurrentUser: [String])

    func observeMatchCardUsersError(_ error: Error)

}

class MatchCardUsersManager {

    weak var delegate: MatchCardUsersManagerProtocol?

    var matchCardUsers = [IPetUser]()

    var usersIdLikedByCurrentUser = [String]()

    func observeLikesSentByCurrentUser() {

        guard let fromId = Auth.auth().currentUser?.uid else { return }

        let ref = Database.database().reference().child("user-sentLikes").child(fromId)
        ref.queryOrderedByKey().observe(.value) { snapshot in

            guard let usersDic = snapshot.value as? [String: Any] else { return }

            var usersId = [String]()
            for userId in usersDic.keys {

                usersId.append(userId)
            }

            self.usersIdLikedByCurrentUser = usersId

            self.delegate?.didobserveLikesSentByCurrentUser(manager: self, usersIdLikedByCurrentUser: self.usersIdLikedByCurrentUser)
        }

    }

    func observeMatchCardUsers() {

        let matchCardUsersRef = Database.database().reference().child(FirebaseSchema.users.rawValue)

        matchCardUsersRef.queryOrdered(byChild: IPetUser.Schema.petPersonType).observe(.value) {[weak self] (snapShot) in

            guard let data = snapShot.value as? [String: AnyObject] else {

                SCLAlertView().showInfo(NSLocalizedString("No user found", comment: ""),
                                            subTitle: NSLocalizedString("Change filter to find more users", comment: ""))
                return
            }

            for (userUid, userData) in data {

                if userUid != Auth.auth().currentUser?.uid {

                    guard let userDic = userData as? [String: Any] else {

                        return
                    }

                    guard
                        let email = userDic[IPetUser.Schema.loginEmail] as? String,
                        let name = userDic[IPetUser.Schema.name] as? String,
                        let imageURL = userDic[IPetUser.Schema.imageURL] as? String,
                        let callingID = userDic[IPetUser.Schema.callingID] as? Int,
                        let yearOfBirth = userDic[IPetUser.Schema.yearOfBirth] as? Int,
                        let gender = userDic[IPetUser.Schema.gender] as? String,
                        let petPersionType = userDic[IPetUser.Schema.petPersonType] as? String else {

                            //self.delegate?.observeMatchCardUsersError(Error)

                            return

                    }

                    let ipetUser = IPetUser(id: userUid, loginEmail: email, name: name, petPersonType: PetPersonType(rawValue: petPersionType)!, gender: Gender(rawValue: gender)!, yearOfBirth: yearOfBirth, imageURL: imageURL, callingID: UInt(callingID))

                    self?.matchCardUsers.append(ipetUser)

                }

            }
            if let matchCardUsers = self?.matchCardUsers {

                self?.delegate?.didObserveMatchCardUsers(matchCardUsers)

            }

        }

    }

}

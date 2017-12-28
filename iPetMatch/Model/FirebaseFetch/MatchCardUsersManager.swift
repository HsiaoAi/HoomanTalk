//
//  MatchCardUsersManager.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 28/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import Foundation

protocol MatchCardUsersManagerProtocol: class {

    func didObserveMatchCardUsers(_ matchCardUsers: [MatchCardUser])

    func observeMatchCardUsersError(_ error: Error)

}

class MatchCardUsersManager {

    static var instance = MatchCardUsersManager()

    weak var delegate: MatchCardUsersManagerProtocol?

    var matchCardUsers = [MatchCardUser]()

    func observeMatchCardUsers() {

        let matchCardUsersRef = Database.database().reference().child(FirebaseSchema.users.rawValue)

        matchCardUsersRef.queryOrdered(byChild: MatchCardUser.Schema.petPersonType).observe(.value) {[weak self] (snapShot) in

            guard let data = snapShot.value as? [String: AnyObject] else {

                //self.delegate?.observeMatchCardUsersError(Error)

                return
            }

            for (userUid, userData) in data {

                if userUid != Auth.auth().currentUser?.uid {

                    guard let userDic = userData as? [String: Any] else {

                        return
                    }

                    guard
                        let name = userDic[MatchCardUser.Schema.name] as? String,
                        let imageURL = userDic[MatchCardUser.Schema.imageURL] as? String,
                        let callingID = userDic[MatchCardUser.Schema.callingID] as? Int,
                        let yearOfBirth = userDic[MatchCardUser.Schema.yearOfBirth] as? Int,
                        let gender = userDic[MatchCardUser.Schema.gender] as? String,
                        let petPersionType = userDic[MatchCardUser.Schema.petPersonType] as? String else {

                            //self.delegate?.observeMatchCardUsersError(Error)

                            return

                    }

                    let matchCardUser = MatchCardUser(id: userUid, name: name, petPersonType: PetPersonType(rawValue: petPersionType)!, gender: Gender(rawValue: gender)!, yearOfBirth: yearOfBirth, imageURL: imageURL, callingID: UInt(callingID))

                    self?.matchCardUsers.append(matchCardUser)

                }

            }
            if let matchCardUsers = self?.matchCardUsers {

                self?.delegate?.didObserveMatchCardUsers(matchCardUsers)

            }

        }

    }

}

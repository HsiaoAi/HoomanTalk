//
//  FetchUsersManager.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 28/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import Foundation

protocol FetchUsersManagerProtocol: class {

    func didFetchUsers(_ fetchUsers: [MatchUser])

    func didFetchUsersError(_ fetchUserError: Error)

}

class FetchUsersManager {

    static var instance = FetchUsersManager()

    weak var delegate: FetchUsersManagerProtocol?

    var matchUsers = [MatchUser]()

    func query() {

        let matchUsersRef = Database.database().reference().child(FirebaseSchema.users.rawValue)

        matchUsersRef.queryOrdered(byChild: MatchUser.Schema.petPersonType).observe(.value) {[weak self] (snapShot) in

            guard let data = snapShot.value as? [String: AnyObject] else {

                //self.delegate?.didFetchUsersError(Error)

                return
            }

            for (userUid, userData) in data {

                if userUid != Auth.auth().currentUser?.uid {

                    guard let userDic = userData as? [String: Any] else {

                        return
                    }

                    guard
                        let name = userDic["name"] as? String,
                        let imageURL = userDic[MatchUser.Schema.imageURL] as? String,
                        let callingID = userDic[MatchUser.Schema.callingID] as? Int,
                        let yearOfBirth = userDic[MatchUser.Schema.yearOfBirth] as? Int,
                        let gender = userDic[MatchUser.Schema.gender] as? String,
                        let petPersionType = userDic[MatchUser.Schema.petPersonType] as? String else {

                            //self.delegate?.didFetchUsersError(Error)

                            return

                    }

                    let matchUser = MatchUser(name: name, petPersonType: PetPersonType(rawValue: petPersionType)!, gender: Gender(rawValue: gender)!, yearOfBirth: yearOfBirth, imageURL: imageURL, callingID: UInt(callingID))

                    self?.matchUsers.append(matchUser)

                }

            }
            if let matchUsers = self?.matchUsers {

                self?.delegate?.didFetchUsers(matchUsers)

            }

        }

    }

}

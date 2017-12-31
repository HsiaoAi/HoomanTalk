//
//  FriendsProvider.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 30/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

protocol  FriendsProviderProtocol: class {

    func didObserveMyFriends(_ provider: FriendProvider, _ friends: [Friend])
}

class FriendProvider {
    weak var delegate: FriendsProviderProtocol?

    func observeMyFriends() {
        guard let uid = Auth.auth().currentUser?.uid else {

            SCLAlertView().showError(NSLocalizedString("Error", comment: ""),
                                     subTitle: NSLocalizedString("User didn't log in", comment: ""))
            return
        }

        let ref = Database.database().reference().child("user-friends").child(uid)
        ref.observe(.childAdded) { [weak self] (snapshot) in
            ref.observeSingleEvent(of: .value, with: { snapshot in
                var myFriends = [Friend]()
                if let friendsDic = snapshot.value as? [String: Any] {

                    for (friendId, friendData) in friendsDic {

                        guard let friendDic = friendData as? [String: Any] else {

                            return
                        }

                        let friend = Friend(dictionary: friendDic)
//                        guard
//                            //let email = friendDic[IPetUser.Schema.loginEmail] as? String,
//                            let name = friendDic[IPetUser.Schema.name] as? String,
//                            let imageURL = friendDic[IPetUser.Schema.imageURL] as? String,
//                            let callingID = friendDic[IPetUser.Schema.callingID] as? Int,
//                            let yearOfBirth = friendDic[IPetUser.Schema.yearOfBirth] as? Int,
//                            let gender = friendDic[IPetUser.Schema.gender] as? String,
//                            let petPersionType = friendDic[IPetUser.Schema.petPersonType] as? String else {
//
//                                return
//                        }
//
//                        let ipetUser = IPetUser(id: friendId, loginEmail:"", name: name, petPersonType: PetPersonType(rawValue: petPersionType)!, gender: Gender(rawValue: gender)!, yearOfBirth: yearOfBirth, imageURL: imageURL, callingID: UInt(callingID))

                        myFriends.append(friend)
                    }

                    self?.delegate?.didObserveMyFriends(self!, myFriends)

                } else {

                    SCLAlertView().showWarning(NSLocalizedString("Warning", comment: ""),
                                             subTitle: NSLocalizedString("You don't have friends", comment: ""))

                }
            })
        }
    }
}

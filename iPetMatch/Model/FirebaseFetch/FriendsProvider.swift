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

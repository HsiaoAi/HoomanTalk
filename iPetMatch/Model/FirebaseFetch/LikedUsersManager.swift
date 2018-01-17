//
//  LikedUsersManager.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 29/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

protocol LikedUsersMangerProtocol: class {

    func didObserveReceivedLikes(_ likedMeUsers: [IPetUser])
    func observeReceivedLikesError(_ error: Error)
}

class LikedUsersManger {

    weak var delegate: LikedUsersMangerProtocol?

    var likeMeUsers = [IPetUser]()

    func sendLike(to user: IPetUser) {

        guard let fromUser = Auth.auth().currentUser,
            let currentUser = UserManager.instance.currentUser else {

                SCLAlertView().showWarning(NSLocalizedString("Warning", comment: ""),
                                           subTitle: NSLocalizedString("User didn't log it", comment: ""))
                return
        }

        let fromId = fromUser.uid
        let toId = user.id

        let ref = Database.database().reference().child(FirebaseSchema.likes.rawValue)
        let childRef = ref.childByAutoId()
        let values: [String: Any] = [Like.Schema.fromID: fromId,
                                     Like.Schema.toID: toId,
                                     Like.Schema.timestamp: Like.getCurrentDate()]
        childRef.updateChildValues(values)

        let userSentLikeRef = Database.database().reference().child("user-sentLikes").child(fromId)
        userSentLikeRef.updateChildValues([toId: Like.getCurrentDate()])

        let userReceivedLikeRef = Database.database().reference().child("user-ReceivedLikes").child(toId).child(fromId)

        let likeInfo: [String: Any] = [

            IPetUser.Schema.loginEmail: currentUser.loginEmail,
            IPetUser.Schema.name: currentUser.name,
            IPetUser.Schema.petPersonType: currentUser.petPersonType.rawValue,
            IPetUser.Schema.gender: currentUser.gender.rawValue,
            IPetUser.Schema.yearOfBirth: currentUser.yearOfBirth,
            IPetUser.Schema.imageURL: currentUser.imageURL ?? "",
            IPetUser.Schema.callingID: currentUser.callingID,
            FirebaseSchema.timeStamp.rawValue: Like.getCurrentDate()

        ]

        userReceivedLikeRef.updateChildValues(likeInfo)
        pushReceivedLikeNotifictaion(from: currentUser.name, toUserId: "\(user.callingID)")

    }

    func pushReceivedLikeNotifictaion(from userName: String, toUserId userCallingID: String) {

        let pushMessage = NSLocalizedString("Someone likes you! Come back to check it.", comment: "")

        QBRequest.sendPush(withText: pushMessage,
                           toUsers: userCallingID,

                           successBlock: {(_, _) -> Void in

                            print("+++Push Done")},

                           errorBlock: {(_ error: QBError) -> Void in

                            print("Push error \(error)")

        })

    }

    func observeReceivedLikes() {

        guard let uid = Auth.auth().currentUser?.uid else {

            SCLAlertView().showWarning(NSLocalizedString("Warning", comment: ""),
                                       subTitle: NSLocalizedString("User didn't log it", comment: ""))
            return
        }

        let toId = uid

        let userReceivedLikeRef = Database.database().reference().child("user-ReceivedLikes").child(toId)

        userReceivedLikeRef.observe(.value) {[weak self] (snapshot) in

            self?.likeMeUsers.removeAll()

            guard let likeDics = snapshot.value as? [String: Any] else { return }

            for (userId, userData) in likeDics {

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

                let ipetUser = IPetUser(id: userId, loginEmail: email, name: name, petPersonType: PetPersonType(rawValue: petPersionType)!, gender: Gender(rawValue: gender)!, yearOfBirth: yearOfBirth, imageURL: imageURL, callingID: UInt(callingID))

                self?.likeMeUsers.append(ipetUser)

            }

            if self?.likeMeUsers != nil {

                self?.delegate?.didObserveReceivedLikes((self?.likeMeUsers)!)

            }

        }

    }

}

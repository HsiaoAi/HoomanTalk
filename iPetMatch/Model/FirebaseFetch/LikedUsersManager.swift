//
//  LikedUsersManager.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 29/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

protocol LikedUsersMangerProtocol: class {

    func didObserveReceivedLikes(_ likedMeUsers: [LikeMe])
    func observeReceivedLikesError(_ error: Error)
}

class LikedUsersManger {

    static let instance = LikedUsersManger()
    weak var delegate: LikedUsersMangerProtocol?
    var likesForMe = [LikeMe]()

    func didLikeUser(with user: MatchCardUser) {

        guard let uid = Auth.auth().currentUser?.uid,
            let currentUser = UserManager.instance.currentUser else {

            SCLAlertView().showWarning(NSLocalizedString("Warning", comment: ""),
                                       subTitle: NSLocalizedString("User didn't log it", comment: ""))
            return
        }
        
        let fromId = uid
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
        
        let likeInfo: [String: Any] = [LikeMe.Schema.fromUserName: currentUser.name as Any,
                                     LikeMe.Schema.fromUserImageURL: currentUser.imageURL as Any,
                                     LikeMe.Schema.timestamp: Like.getCurrentDate() as Any]

        userReceivedLikeRef.updateChildValues(likeInfo)

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
            
            guard let likeDics = snapshot.value as? [String: Any] else { return }
            
            for (userId, userInfo) in likeDics {
                
                guard let userDic = userInfo as? [String: Any] else { return }
                guard let name = userDic[LikeMe.Schema.fromUserName] as? String,
                    let imageURL = userDic[LikeMe.Schema.fromUserImageURL] as? String,
                    let timeStamp = userDic[LikeMe.Schema.timestamp] as? Int else { return }
                
                let likeMe = LikeMe(fromUserName: name, fromUserImageURL: imageURL, timestamp: timeStamp)
                
                self?.likesForMe.append(likeMe)
                
            }
            guard let likesForMe = self?.likesForMe else { return }
            self?.delegate?.didObserveReceivedLikes(likesForMe)
        
        
        }
        
        
    }

}

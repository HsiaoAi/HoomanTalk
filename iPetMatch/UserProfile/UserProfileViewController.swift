//
//  UserProfileViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 04/01/2018.
//  Copyright © 2018 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var backgroundUserImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPetTypeLabel: UILabel!
    @IBOutlet weak var userGenderLabel: UILabel!
    @IBOutlet weak var userBirthLabel: UILabel!
    @IBOutlet weak var userLikeNumberLabel: UILabel!
    @IBOutlet weak var likedUserLabel: UILabel!
    @IBOutlet weak var friendsNumberLabel: UILabel!
    @IBOutlet weak var loadingImageView: NVActivityIndicatorView!

    @IBAction func tapLogout(_ sender: UIButton) {

        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertview = SCLAlertView(appearance: appearance)
        let buttonYes = NSLocalizedString("Yes", comment: "")
        let buttonNo = NSLocalizedString("No", comment: "")

        alertview.addButton(buttonYes) {
            self.logout()
        }
        alertview.addButton(buttonNo) { }
        alertview.showNotice(NSLocalizedString("Notice", comment: ""),
                             subTitle: NSLocalizedString("Are you sure to log out?", comment: ""))
    }

    func logout() {

        do {
            try Auth.auth().signOut()
        } catch {

            SCLAlertView().showError(
                NSLocalizedString("Error", comment: ""),
                subTitle: NSLocalizedString("Something wrong, please try again", comment: "")
            )
            print(error)
        }
        let deviceIdentifier = UIDevice.current.identifierForVendor?.uuidString

        QBRequest.unregisterSubscription(forUniqueDeviceIdentifier: deviceIdentifier!, successBlock: nil, errorBlock: nil)

        QBRequest.logOut(successBlock: { _ in
            UserManager.instance.currentUser = nil
            AppDelegate.shared.enterLandingView()

        }, errorBlock: nil)
    }

    var friendNumber: Int = 0 {
        didSet {
            friendsNumberLabel.text = NSLocalizedString("Friends", comment: "") + ": \(String(describing: friendNumber))"
        }
    }

    var likeNumber: Int = 0 {
        didSet {
            userLikeNumberLabel.text = NSLocalizedString("Likes", comment: "") + ": \(String(describing: likeNumber))"
        }
    }

    var likedNumber: Int = 0 {
        didSet {
            likedUserLabel.text = NSLocalizedString("Liked", comment: "") + ": \(String(describing: likedNumber))"
        }
    }

    var todayYear: Int {

        let todayDate: Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let todayYesrString = dateFormatter.string(from: todayDate)
        return Int(todayYesrString)!

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInfo()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    func setupUserInfo() {
        guard let user = UserManager.instance.currentUser else {
            SCLAlertView().showError(NSLocalizedString("Error", comment: ""),
                                     subTitle: NSLocalizedString("Can't load user's information", comment: ""))
            return
        }
        let friendRef = Database.database().reference().child("user-friends").child(user.id)
        friendRef.observe(.value) { snapshot in
            if let friendDics = snapshot.value as? [String: Any] {
                self.friendNumber = friendDics.keys.count
            } else {
                self.friendNumber = 0
            }
        }

        let likesRef = Database.database().reference().child("user-sentLikes").child(user.id)
        likesRef.observe(.value) { snapshot in
            if let likeDics = snapshot.value as? [String: Any] {
                self.likeNumber = likeDics.keys.count
            } else {
                self.likeNumber = 0
            }
        }

        let likedRef = Database.database().reference().child("user-ReceivedLikes").child(user.id)
        likedRef.observe(.value) { snapshot in
            if let likedDics = snapshot.value as? [String: Any] {
                self.likedNumber = likedDics.keys.count
            } else {
                self.likedNumber = 0
            }
        }

        let imageAdress = user.imageURL
        if let imageURL = URL(string: imageAdress!) {

            UserManager.setUserProfileImage(with: imageURL, into: userImageView, activityIndicatorView: loadingImageView)
            UserManager.setUserProfileImage(with: imageURL, into: backgroundUserImageView, activityIndicatorView: nil)
        }
        userNameLabel.text = user.name
        switch user.petPersonType {
        case .dog:
            userPetTypeLabel.text = "🐶" +  NSLocalizedString("Person", comment: "")

        case .cat:
            userPetTypeLabel.text = "🐱" +  NSLocalizedString("Person", comment: "")

        case .both:
            userPetTypeLabel.text = "❤️ 🐶 & 🐱"

        }
        let im = NSLocalizedString("I'm", comment: "")
        switch user.gender {
        case .female:
            userGenderLabel.text = im + "🙋🏻‍♀️"
        case .male:
            userGenderLabel.text = im + "🙋🏻‍♂️"
        }
        let yearsOld = NSLocalizedString("yrs", comment: "")
        userBirthLabel.text = "\(todayYear - user.yearOfBirth) " + yearsOld

    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

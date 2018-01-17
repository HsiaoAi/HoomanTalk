//
//  UserProfileViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 04/01/2018.
//  Copyright © 2018 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var editPanel: UIView!
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
    let loadingImagesManager = LoadingImagesManager()
    var displayUser: IPetUser?

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
        editPanel.isHidden = true
        setupUserInfo()
        hideNavigationBar()
    }

    func hideNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }

    func setupUserInfo() {
        guard let user = UserManager.instance.currentUser else {
            SCLAlertView().showError(NSLocalizedString("Error", comment: ""),
                                     subTitle: NSLocalizedString("Can't load user's information", comment: ""))
            return
        }
        self.displayUser = user
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
        loadingImagesManager.downloadAndCacheImage(urlString: imageAdress!, imageView: userImageView, activityIndicatorView: loadingImageView, placeholderImage: nil)
        loadingImagesManager.downloadAndCacheImage(urlString: imageAdress!, imageView: backgroundUserImageView, activityIndicatorView: loadingImageView, placeholderImage: nil)
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

    @IBAction func tapEditButton(_ sender: Any) {
        let editStoryboard = UIStoryboard(name: "EditProfile", bundle: nil)
        if let editViewController = editStoryboard.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController {
            editViewController.user = self.displayUser
            if let userImage = self.userImageView.image {
                editViewController.userImage = userImage
                self.present(editViewController, animated: true, completion: nil)
            } else {
                return

            }
        }
    }
    @IBAction func tapFilterButton(_ sender: Any) {
        let filterStoryboard = UIStoryboard(name: "Filter", bundle: nil)
        let filterViewController = filterStoryboard.instantiateViewController(withIdentifier: "FilterViewController")
        self.navigationController?.pushViewController(filterViewController, animated: true)
        //self.present(filterViewController, animated: true, completion: nil)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

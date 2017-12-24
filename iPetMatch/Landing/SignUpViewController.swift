//
//  SignUpViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 22/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var userImageView: UIImageView!

    var petPersonType: PetPersonType = .none

    var isCatPerson: Bool = false

    var isDogPerson: Bool = false

    var userImage: UIImage?

    override func viewDidLoad() {

        super.viewDidLoad()

        setupFusumaImagePicker()

    }

    @IBAction func tapSignupButton(_ sender: LGButton) {

        signUp()

    }

    @IBAction func addUserImage (_ sender: Any) {

        self.setupFusumaImagePicker()

    }

    @IBAction func tapCatPerson(_ sender: LGButton) {

        if !sender.isSelected {

            sender.isSelected = true

            isCatPerson = true

            sender.rightImageSrc = IconImage.catPersonSelected.image

        } else {

            sender.isSelected = false

            isCatPerson = false

            sender.rightImageSrc = IconImage.catPerson.image

        }

    }

    @IBAction func tapDogPerson(_ sender: LGButton) {

        if !sender.isSelected {

            sender.isSelected = true

            isDogPerson = true

            sender.rightImageSrc = IconImage.dogPersonSelected.image

        } else {

            sender.isSelected = false

            isDogPerson = false

            sender.rightImageSrc = IconImage.dogPerson.image

        }

    }

    func signUp() {

        // Todo: Alert

        guard let email = emailTextField.text else {

            return

        }

        guard let name = nameTextField.text else {

            return
        }

        guard let password = passwordTextField.text,

            password.characters.count > 5 else {

                return

        }

        var currentUser = QBUUser()

        currentUser.login = email

        currentUser.password = password

        QBRequest.signUp(currentUser,

                         successBlock: { _, _ in

                            let tabBarController = TabBarController(itemTypes: [.chat])

                            AppDelegate.shared.window?.rootViewController = tabBarController },

                         errorBlock: nil )

    }

    func logOut() {

        QBRequest.logOut(
            successBlock: nil,
            errorBlock: nil
        )
    }

}

extension SignUpViewController: FusumaDelegate {

    func setupFusumaImagePicker() {

        let fusuma = FusumaViewController()

        fusuma.delegate = self

        fusuma.cropHeightRatio = 1.0

        fusuma.allowMultipleSelection = false

        self.present(fusuma, animated: true, completion: nil)

    }

    // Delegate Methods
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {

        self.userImage = image

        userImageView.image = image

        userImageView.contentMode = .scaleAspectFill

        userImageView.clipsToBounds = true

        // Upload image to Firebase and get the url

    }

    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {

        print("Camera roll unauthorized")

    }

    // Empty delegate functions
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {

    }

    func fusumaVideoCompleted(withFileURL fileURL: URL) {

    }

}

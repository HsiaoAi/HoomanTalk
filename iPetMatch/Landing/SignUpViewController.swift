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

    var petPersonType: PetPersonType = .none

    var userImage: String?

    override func viewDidLoad() {

        super.viewDidLoad()

        setupFusumaImagePicker()

    }

    @IBAction func tapSignupButton(_ sender: LGButton) {

        signUp()

    }

    @IBAction func tapAddPict(_ sender: Any) {

        print("Tap")
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

        fusuma.hasVideo = false

    }

    // Delegate Methods
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {

    }

    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {

    }

    func fusumaVideoCompleted(withFileURL fileURL: URL) {

    }

    func fusumaCameraRollUnauthorized() {

    }

}

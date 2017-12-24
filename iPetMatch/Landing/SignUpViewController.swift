//
//  SignUpViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 22/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var userIDTextField: UITextField!

    @IBOutlet weak var userEmailTextField: UITextField!

    @IBOutlet weak var userPasswordTextField: UITextField!

    override func viewDidLoad() {

        super.viewDidLoad()

    }

    @IBAction func tapSignupButton(_ sender: LGButton) {

        signUp()

    }

    @IBAction func tapAddPict(_ sender: Any) {

        print("Tap")
    }

    func signUp() {

        let loginID = userIDTextField.text!

        let email = userEmailTextField.text!

        let password = userPasswordTextField.text!

        var currentUser = QBUUser()

        currentUser.login = loginID

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

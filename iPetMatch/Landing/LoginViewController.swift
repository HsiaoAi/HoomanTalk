//
//  LoginViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 21/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextFied: SkyFloatingLabelTextField!

    @IBOutlet weak var passwordTextFied: SkyFloatingLabelTextField!

    override func viewDidLoad() {

        super.viewDidLoad()

        setupErrorTextFieldHandeler()

    }

    @IBAction func tapLogin(_ sender: Any) {

        login()

    }

    func login() {

            let loginID = emailTextFied.text!

            let password = passwordTextFied.text!

            let currentUser = QBUUser()

            currentUser.login = loginID

            currentUser.password = password

            QBRequest.logIn(withUserLogin: loginID, password: "12341234",

                            successBlock: { _, user in QBChat.instance.connect(

                                with: user,

                                completion: { error in

                                    if error != nil { print(error) }

                                    let tabBarController = TabBarController(itemTypes: [.chat])

                                    AppDelegate.shared.window?.rootViewController = tabBarController
                            }) },

                            errorBlock: nil )
        }

}

extension LoginViewController: UITextFieldDelegate {

    func setupErrorTextFieldHandeler() {

        emailTextFied.delegate = self

        emailTextFied.tag = 1

        passwordTextFied.delegate = self

        passwordTextFied.tag = 2
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if let text = textField.text {

            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {

                if textField.tag == 1 && (text.count < 3 || !text.contains("@")) {

                    floatingLabelTextField.errorMessage = "Invalid Email"

                } else if textField.tag == 2 && text.count < 5 {
                    floatingLabelTextField.errorMessage = "Invalid Password"

                } else {

                    floatingLabelTextField.errorMessage = ""

                }

            }

        }

        return true

    }

}

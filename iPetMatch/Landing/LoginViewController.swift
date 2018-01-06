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

    @IBOutlet weak var loginButton: LGButton!

    override func viewDidLoad() {

        super.viewDidLoad()
        setup()
            }

    func setup() {
        loginButton.titleString = NSLocalizedString("Log in", comment: "")

        let email = NSLocalizedString("Email", comment: "")
        emailTextFied.title = email
        emailTextFied.placeholder = email

        let password = NSLocalizedString("Password", comment: "")
        passwordTextFied.title = password
        passwordTextFied.placeholder = password
        passwordTextFied.selectedTitle = NSLocalizedString("Password (6-20 Characters)", comment: "")
        loginButton.loadingString = NSLocalizedString("Loading...)", comment: "")
    }

    @IBAction func tapForgetPassword(_ sender: UIButton) {

        let email = emailTextFied.text!
        guard email != "" else {

            SCLAlertView().showWarning(
                NSLocalizedString("Warning", comment: ""),
                subTitle: NSLocalizedString("Please enter your email", comment: "")
            )

            return

        }

        guard email.contains("@") else {
            SCLAlertView().showWarning(
                NSLocalizedString("Warning", comment: ""),
                subTitle: NSLocalizedString("Invalid Email", comment: "")
            )
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { error in

            guard error == nil else {

                SCLAlertView().showError(
                    NSLocalizedString("Error", comment: ""),
                    subTitle: NSLocalizedString("User not found with this email", comment: "")
                )

                return
            }

            SCLAlertView().showInfo(
                NSLocalizedString("Information", comment: ""),
                subTitle: NSLocalizedString("Please check the password reset email", comment: "")
            )

        }

        return

    }

    @IBAction func tapLogin(_ sender: Any) {

        login()

    }

    func login() {

        let email = emailTextFied.text!
        guard email != "" else {
            SCLAlertView().showWarning(
                NSLocalizedString("Warning", comment: ""),
                subTitle: NSLocalizedString("Please enter your email", comment: "")
            )
            return
        }

        guard email.contains("@") else {
            SCLAlertView().showWarning(
                NSLocalizedString("Warning", comment: ""),
                subTitle: NSLocalizedString("Invalid Email", comment: "")
            )
            return
        }

        guard
            let password = passwordTextFied.text,
            password != ""
            else {
                SCLAlertView().showWarning(
                    NSLocalizedString("Warning", comment: ""),
                    subTitle: NSLocalizedString("Please enter password", comment: "")
                )
                return
        }

        guard password.count > 5 else {
            SCLAlertView().showWarning(
                NSLocalizedString("Warning", comment: ""),
                subTitle: NSLocalizedString("Invalid Password\n(6-20 Characters)", comment: "")
            )
            return
        }

        loginButton.isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let authError = error {
                if let errCode = AuthErrorCode(rawValue: authError._code) {
                    self.loginButton.isLoading = false
                    switch errCode {
                    case.wrongPassword:
                        SCLAlertView().showError(
                            NSLocalizedString("Error", comment: ""),
                            subTitle: NSLocalizedString("Wrong password", comment: "")
                        )
                    case .userNotFound:
                        SCLAlertView().showError(
                            NSLocalizedString("Error", comment: ""),
                            subTitle: NSLocalizedString("Wrong email", comment: "")
                        )
                    default:
                        SCLAlertView().showError(
                            NSLocalizedString("Error", comment: ""),
                            subTitle: NSLocalizedString("Something wrong, plese log in again.", comment: "")
                        )
                        self.emailTextFied.text = ""
                        self.passwordTextFied.text = ""
                        return
                    }
                }
            }
            if let loginUser = user {
                UserManager.instance.upDateCurrentUser(loginUser)
                let uid = loginUser.uid
                QBRequest.logOut(successBlock: nil, errorBlock: nil)

                QBRequest.logIn(withUserEmail: email,
                                password: uid,
                                successBlock: { (_, QBUser) in
                                    UserManager.registerForRemoteNotification()
                                    QBChat.instance.connect(with: QBUser, completion: { (error) in
                                        guard error == nil else {
                                            self.loginButton.isLoading = false
                                            SCLAlertView().showError(
                                                NSLocalizedString("Error", comment: ""),
                                                subTitle: NSLocalizedString("Something wrong, plese log in again", comment: "")
                                            )
                                            return
                                        }
                                        self.loginButton.isLoading = false
                                        AppDelegate.shared.enterPassByLandingView()
                                    })

                                    self.loginButton.isLoading = false
                                    AppDelegate.shared.enterPassByLandingView()},

                                errorBlock: { ( _ ) in
                                    self.loginButton.isLoading = false
                                    SCLAlertView().showError(
                                        NSLocalizedString("Error", comment: ""),
                                        subTitle: NSLocalizedString("Something wrong, plese log in again", comment: "")
                                    )
                                    return}
                )
            }
        }
    }

}

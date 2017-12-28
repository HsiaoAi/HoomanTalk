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

        setupErrorTextFieldHandeler()

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

        guard emailTextFied.errorMessage == "" else {

            SCLAlertView().showWarning(

                NSLocalizedString("Warning", comment: ""),

                subTitle: NSLocalizedString("emailTextField.errorMessage!", comment: "")

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

        guard emailTextFied.errorMessage == "" else {

            SCLAlertView().showWarning(

                NSLocalizedString("Warning", comment: ""),

                subTitle: NSLocalizedString("emailTextField.errorMessage!", comment: "")

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

        guard passwordTextFied.errorMessage == "" else {

            SCLAlertView().showWarning(

                NSLocalizedString("Warning", comment: ""),

                subTitle: NSLocalizedString(passwordTextFied.errorMessage!, comment: "")

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

                        break

                    case .userNotFound:

                        SCLAlertView().showError(
                            NSLocalizedString("Error", comment: ""),
                            subTitle: NSLocalizedString("Wrong email", comment: "")
                        )
                        break

                    default:

                        SCLAlertView().showError(
                            NSLocalizedString("Error", comment: ""),
                            subTitle: NSLocalizedString("Something wrong, plese log in again.\(errCode)", comment: "")
                        )

                        self.emailTextFied.text = ""

                        self.passwordTextFied.text = ""

                        return

                    }

            }
        }

            if let loginUser = user {

                let uid = loginUser.uid

                QBRequest.logOut(successBlock: nil, errorBlock: nil)

                QBRequest.logIn(withUserEmail: email, password: uid, successBlock: { (_, QBUser) in

                    if QBChat.instance.isConnected == false {

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

                    }

                    self.loginButton.isLoading = false

                    AppDelegate.shared.enterPassByLandingView()

                }, errorBlock: { ( errorResponse ) in

                    self.loginButton.isLoading = false

                    SCLAlertView().showError(
                        NSLocalizedString("Error", comment: ""),
                        subTitle: NSLocalizedString("Something wrong, plese log in again: \(errorResponse)", comment: "")
                    )

                    return

                })

                Database.database().reference().child(FirebaseSchema.users.rawValue).child(uid).observeSingleEvent(
                of: .value) {

                    snapShot in

                    guard let userDic = snapShot.value as? [String: Any] else {

                        return
                    }

                    guard
                        let name = userDic[CurrentUser.Schema.name] as? String,
                        let email = userDic[CurrentUser.Schema.loginEmail] as? String,
                        let imageURL = userDic[CurrentUser.Schema.imageURL] as? String,
                        let callingID = userDic[CurrentUser.Schema.callingID] as? Int,
                        let yearOfBirth = userDic[CurrentUser.Schema.yearOfBirth] as? Int,
                        let gender = userDic[CurrentUser.Schema.gender] as? String,
                        let petPersionType = userDic[CurrentUser.Schema.petPersonType] as? String else {

                            return

                    }

                    UserManager.instance.currentUser = CurrentUser(loginEmail: email, name: name, petPersonType: PetPersonType(rawValue: petPersionType)!, gender: Gender(rawValue: gender)!, yearOfBirth: yearOfBirth, imageURL: imageURL, callingID: UInt(callingID))

                    print(UserManager.instance.currentUser)

                }

            }
        }
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

//
//  LandingViewControViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 14/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

class LandingViewControViewController: UIViewController {

    @IBOutlet var avoidingView: UIView!

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextFiled: UITextField!

    @IBAction func tapLogin(_ sender: UIButton) {

        login()

    }

    @IBAction func tapSignUp(_ sender: Any) {

        signUp()

    }

    @IBAction func tapLogOut(_ sender: UIButton) {

        QBRequest.logOut(
            successBlock: nil,
            errorBlock: nil
        )

    }

    override func viewDidLoad() {

        super.viewDidLoad()

        KeyboardAvoiding.avoidingView = self.avoidingView

    }

    func login() {

        let loginID = emailTextField.text!

        let password = passwordTextFiled.text!

        let currentUser = QBUUser()

        currentUser.login = "ilct23"

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

    func signUp() {

        let email = emailTextField.text!

        let password = passwordTextFiled.text!

        var currentUser = QBUUser()

        currentUser.login = email

        currentUser.password = password

        QBRequest.signUp(currentUser,

                         successBlock: { _, _ in

                            let tabBarController = TabBarController(itemTypes: [.chat])

                            AppDelegate.shared.window?.rootViewController = tabBarController },

                         errorBlock: nil )

    }

}

//
//  LoginViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 21/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextFied: UITextField!

    @IBOutlet weak var passwordTextFied: UITextField!

    override func viewDidLoad() {

        super.viewDidLoad()

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

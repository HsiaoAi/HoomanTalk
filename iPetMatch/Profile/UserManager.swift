//
//  UserManager.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 21/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import Foundation

class UserManager {

    static let instance = UserManager()

    var currentUser = User()

    func login() {

        let firebaseLoginID = currentUser

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

    func logOut() {

    QBRequest.logOut(
    successBlock: nil,
    errorBlock: nil
    )
    }

}

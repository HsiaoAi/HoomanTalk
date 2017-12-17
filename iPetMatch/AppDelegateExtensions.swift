//
//  AppDelegateExtensions.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 15/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

extension AppDelegate {

    class var shared: AppDelegate {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return AppDelegate() }

        return appDelegate

    }

    func makeEntryController() -> UIViewController {

        // if login
        // return TabBarController(itemTypes: [.chat])

        // if not login
        return LandingViewControViewController()
    }

}

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

        return UIViewController()
    }

    func enterLandingView() {

        let landingStoryboard = UIStoryboard(name: "Landing", bundle: nil)
        let landingViewController = landingStoryboard.instantiateViewController(withIdentifier: "LandingViewController")
        window?.rootViewController = landingViewController

    }

    func enterPassByLandingView() {

        let tabBarController = TabBarController(itemTypes: [.match, .chat, .pet, .profile])
        self.window?.rootViewController = tabBarController

    }

    func showLoading() {

        SVProgressHUD.show(withStatus: NSLocalizedString("Loading", comment: ""))

    }

}

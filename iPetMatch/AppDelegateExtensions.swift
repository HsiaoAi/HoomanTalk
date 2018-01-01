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
        
        let langdingStoryboard = UIStoryboard(name: "Landing", bundle: nil)
        let landingViewController = langdingStoryboard.instantiateViewController(withIdentifier: "LandingViewController")
        window?.rootViewController = landingViewController
        
    }
    
    func enterPassByLandingView() {
        
        let tabBarController = TabBarController(itemTypes: [.match, .chat])
        self.window?.rootViewController = tabBarController
        
    }
    
    func showLoading() {
        
        SVProgressHUD.show(withStatus: NSLocalizedString("Loading", comment: ""))
        
    }

}

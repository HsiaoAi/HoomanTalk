//
//  AppDelegate.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 13/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

let kQBRingThickness: CGFloat = 1.0

let kQBAnswerTimeInterval: TimeInterval = 240
let kQBDialingTimeInterval: TimeInterval = 5.0

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Set rootViewController
        let langdingStoryboard = UIStoryboard(name: "Landing", bundle: nil)
        let landingViewController = langdingStoryboard.instantiateViewController(withIdentifier: "LandingViewController")

        window = UIWindow(frame: UIScreen.main.bounds)

        //let vc = LandingViewControViewController()

        //let navigationController = UINavigationController(rootViewController: vc)

        window?.rootViewController = landingViewController

        window?.makeKeyAndVisible()

        // IQKeyboard

        IQKeyboardManager.sharedManager().enable = true

        // Quickblox API

        // Set QuickBlox credentials (You must create application in admin.quickblox.com).

        guard

            let APIKeysPath = Bundle.main.path(forResource: "QuickBloxKey", ofType: "plist"),

            let plistDic = NSDictionary(contentsOfFile: APIKeysPath) as? [String: Any],

            let accountKey = plistDic[QuickBloxAdmin.accountKey] as? String,

            let applicationID = plistDic[QuickBloxAdmin.applicationID] as? UInt,

            let authKey = plistDic[QuickBloxAdmin.authKey] as? String,

            let authSecret = plistDic[QuickBloxAdmin.authSecret] as? String else {

                print("QuickBlox credentials fail")

                return false

        }

        QBSettings.accountKey = accountKey
        QBSettings.applicationID = applicationID
        QBSettings.authKey = authKey
        QBSettings.authSecret = authSecret

        QBSettings.logLevel = .errors
        QBSettings.enableXMPPLogging()

        QBRTCConfig.setAnswerTimeInterval(kQBAnswerTimeInterval)
        QBRTCConfig.setDialingTimeInterval(kQBDialingTimeInterval)
        QBRTCConfig.setStatsReportTimeInterval(1.0)

        SVProgressHUD.setDefaultMaskType(.gradient)
        QBRTCClient.initializeRTC()

        QBRTCAudioSession.instance().initialize()

        // loading settings
        //Settings.instance()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

        // 判斷是否登入

        if QBChat.instance.isConnected {

            // Main Page

            print(QBChat.instance.isConnected)

            let chatListTableViewController = ChatListTableViewController()

            let navigationController = UINavigationController(rootViewController: chatListTableViewController)

            window?.rootViewController = navigationController

        } else {

            // Login Page

            //let landingViewController = LandingViewController()

//            let navigationController = UINavigationController(rootViewController: landingViewController)
//
//            window?.rootViewController = navigationController

        }

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {

    }

}

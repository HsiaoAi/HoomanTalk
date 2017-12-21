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

        // Try function

        // Set rootViewController
        let landingViewController = LandingViewControViewController()

        let navigationController = UINavigationController(rootViewController: landingViewController)

        window = UIWindow(frame: UIScreen.main.bounds)

        let vc = ChatListTableViewController()

        //window?.rootViewController = vc

        window?.rootViewController = navigationController

        window?.makeKeyAndVisible()

        // Quickblox API

        guard let APIKeysPath = Bundle.main.path(forResource: "QuickBloxKey", ofType: "plist") else {

            print(QuickBloxAdminError.plistFileNotFound)

            return false

        }

        guard let plistDic = NSDictionary(contentsOfFile: APIKeysPath) as? [String: Any] else {

            print(QuickBloxAdminError.invalidRootDictionary)

            return false

        }

        guard let accountKey = plistDic[QuickBloxAdmin.accountKey] as? String else {

            print(QuickBloxAdminError.invalidAccountKey)

            return false }

        guard let applicationID = plistDic[QuickBloxAdmin.applicationID] as? UInt else {

            print(QuickBloxAdminError.invalidApplicationID)

            return false }

        guard let authKey = plistDic[QuickBloxAdmin.authKey] as? String else {

            print(QuickBloxAdminError.invalidAuthKey)

            return false }

        guard let authSecret = plistDic[QuickBloxAdmin.authSecret] as? String else {

            print(QuickBloxAdminError.invalidAuthSecret)

            return false }

        QBSettings.accountKey = accountKey
        QBSettings.applicationID = applicationID
        QBSettings.authKey = authKey
        QBSettings.authSecret = authSecret

        QBSettings.logLevel = .debug
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

            let chatListTableViewController = ChatListTableViewController()

            let navigationController = UINavigationController(rootViewController: chatListTableViewController)

            window?.rootViewController = navigationController

        } else {

            // Login Page

            let landingViewController = LandingViewControViewController()

            let navigationController = UINavigationController(rootViewController: landingViewController)

            window?.rootViewController = navigationController

        }

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {

    }

}

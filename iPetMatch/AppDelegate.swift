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
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        // Firebase
        FirebaseApp.configure()
        Fabric.sharedSDK().debug = true

        // IQKeyboard

        IQKeyboardManager.sharedManager().enable = true

        // Quickblox API

        guard

            let APIKeysPath = Bundle.main.path(forResource: "QuickBloxKey", ofType: "plist"),

            let plistDic = NSDictionary(contentsOfFile: APIKeysPath) as? [String: Any],
            let accountKey = plistDic[QuickBloxAdmin.accountKey] as? String,
            let applicationID = plistDic[QuickBloxAdmin.applicationID] as? UInt,
            let authKey = plistDic[QuickBloxAdmin.authKey] as? String,
            let authSecret = plistDic[QuickBloxAdmin.authSecret] as? String else {
                //print("QuickBlox credentials fail")
                return false
        }

        QBSettings.accountKey = accountKey
        QBSettings.applicationID = applicationID
        QBSettings.authKey = authKey
        QBSettings.authSecret = authSecret
        QBSettings.logLevel = .debug
        QBSettings.enableXMPPLogging()
        QBRTCConfig.setAnswerTimeInterval(kQBAnswerTimeInterval)
        QBRTCConfig.setDialingTimeInterval(kQBDialingTimeInterval)
        QBRTCConfig.setStatsReportTimeInterval(1.0)
        QBRTCClient.initializeRTC()

        SVProgressHUD.setDefaultMaskType(.gradient)

        guard
            let user = Auth.auth().currentUser,
            let email = user.email
            else {

                enterLandingView()

                return true }

        showLoading()

        UserManager.instance.upDateCurrentUser(user)

        enterPassByLandingView()

        QBRequest.logIn(withUserEmail: email,
                        password: user.uid,
                        successBlock: { (_, QBuser) in

                            QBChat.instance.connect(with: QBuser, completion: { _ in})},

                        errorBlock: {_ in SVProgressHUD.dismiss() })
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {

        showLoading()
        UIApplication.shared.beginIgnoringInteractionEvents()

        guard let user = Auth.auth().currentUser else {
            enterLandingView()
            SVProgressHUD.dismiss()
            UIApplication.shared.endIgnoringInteractionEvents()
            UserManager.instance.currentUser = nil
            return
        }

        UserManager.instance.upDateCurrentUser(user)

        if let email = user.email {

            QBRequest.logIn(withUserEmail: email,
                            password: user.uid,
                            successBlock: { (_, QBuser) in
                                QBChat.instance.connect(with: QBuser,
                                                        completion: {_ in
                                                            SVProgressHUD.dismiss()
                                                            UIApplication.shared.endIgnoringInteractionEvents()})},
                            errorBlock: {_ in
                                SVProgressHUD.dismiss()
                                UIApplication.shared.endIgnoringInteractionEvents()
                                SCLAlertView().showError(
                                    NSLocalizedString("Error", comment: ""),
                                    subTitle: NSLocalizedString("Please log in", comment: "")
                                )
                                self.enterLandingView()
            })
        }
        UIApplication.shared.endIgnoringInteractionEvents()
        enterPassByLandingView()
    }

    // MARK: - Remote Notifictions
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {

        if notificationSettings.types != .none {
            //print("Did register user notificaiton settings")
            application.registerForRemoteNotifications()
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        let user = QBSession.current.currentUser
        let deviceIdentifier = UIDevice.current.identifierForVendor?.uuidString
        let subscription: QBMSubscription = QBMSubscription()
        subscription.notificationChannel = .APNS
        subscription.deviceUDID = deviceIdentifier
        subscription.deviceToken = deviceToken
        QBRequest.createSubscription(subscription,
                                     successBlock: { (response: QBResponse, _: [QBMSubscription]?) -> Void in
                                        print("Push Subscroption Response: \(response)")},
                                     errorBlock: {(response: QBResponse) in
                                        print("Push Subscroption Error: \(response.error!)")
        })

    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Did receive remote notification", userInfo)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Did receive remote notification", error.localizedDescription)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

        application.applicationIconBadgeNumber = 0
        //QBChat.instance.disconnect(completionBlock: nil)

    }

    func applicationWillTerminate(_ application: UIApplication) {
        QBChat.instance.disconnect(completionBlock: nil)
    }

}

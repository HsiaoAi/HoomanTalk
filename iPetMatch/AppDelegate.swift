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

        // Firebase

        FirebaseApp.configure()

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

                print("QuickBlox credentials fail")

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

        // loading settings
        //Settings.instance()

        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]

        let pushNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)

        application.registerUserNotificationSettings(pushNotificationSettings)

        application.registerForRemoteNotifications()

        // Set rootViewController
        window = UIWindow(frame: UIScreen.main.bounds)

        window?.makeKeyAndVisible()

        guard

            let user = Auth.auth().currentUser,

            let email = user.email

            else {

                enterLandingView()

                return true

        }

        showLoading()

        enterPassByLandingView()

        QBRequest.logIn(withUserEmail: email, password: user.uid, successBlock: { (_, QBuser) in

            QBChat.instance.connect(with: QBuser, completion: {

                _ in SVProgressHUD.dismiss()

            })

            print("done")}, errorBlock: nil)

        return true

    }

        // 判斷是否登入

        func applicationWillEnterForeground(_ application: UIApplication) {

            if QBChat.instance.isConnected == false {

                showLoading()

                UIApplication.shared.beginIgnoringInteractionEvents()

                guard let user = Auth.auth().currentUser else {

                    enterLandingView()

                    SVProgressHUD.dismiss()

                    UIApplication.shared.endIgnoringInteractionEvents()

                    UserManager.instance.currentUser = nil

                    return

                }

                if let email = user.email {

                    QBRequest.logIn(withUserEmail: email, password: user.uid, successBlock: { (_, QBuser) in

                        QBChat.instance.connect(with: QBuser, completion: {

                            _ in

                            SVProgressHUD.dismiss()
                        })

                        print("done")}, errorBlock: nil)

                }

                enterPassByLandingView()

            }
        }

    // MARK: - Remote Notifictions
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {

        if notificationSettings.types != .none {

            print("Did register user notificaiton settings")

            application.registerForRemoteNotifications()

        }

    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        let deviceIdentifier = UIDevice.current.identifierForVendor?.uuidString

        let subscription = QBMSubscription()

        subscription.notificationChannel = .APNS

        subscription.deviceUDID = deviceIdentifier

        subscription.deviceToken = deviceToken

        QBRequest.createSubscription(subscription,

                                     successBlock: {  (_ response: QBResponse,
                                        _ subscription: [QBMSubscription]?) -> Void in

                                        print("Push Subscroption Response: \(response)")

                                         },

                                     errorBlock: {(_ response: QBResponse) in

                                        print("Push Subscroption Error: \(response)")

        })

    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        print("Did receive remote notification", userInfo)

    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

        print("Did receive remote notification", error.localizedDescription)

    }

    func enterLandingView() {

        let langdingStoryboard = UIStoryboard(name: "Landing", bundle: nil)

        let landingViewController = langdingStoryboard.instantiateViewController(withIdentifier: "LandingViewController")

        window?.rootViewController = landingViewController

    }

    func enterPassByLandingView() {

        let chatListTableViewController = ChatListTableViewController()

        let tabBarController = TabBarController(itemTypes: [.match, .chat])

        self.window?.rootViewController = tabBarController

    }

    func showLoading() {

        SVProgressHUD.show(withStatus: NSLocalizedString("Loading", comment: ""))

    }

}

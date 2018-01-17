//
//  SettingsBundleHelper.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 10/01/2018.
//  Copyright © 2018 Hsiao Ai LEE. All rights reserved.
//

import Foundation

class SettingsBundleHelper {

    struct SettingsBundleKeys {
        static let doNotDisturb = "doNotDisturb_preference"
        static let ringtones = "ringtones_preference"
        static let appVersion = "vesion_preference"
        static let appBuildVersion = "build_preference"
    }

    class func checkoutAndExcuteSettings() {

    }

    class func setAppVersionInfo() {
        if let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
            let build: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
            UserDefaults.standard.set(version, forKey: SettingsBundleKeys.appVersion)
            UserDefaults.standard.set(build, forKey: SettingsBundleKeys.appBuildVersion)
        }
    }

    class func registerSettingsBundle() {
        // Do not disturb
        UserDefaults.standard.register(defaults: [SettingsBundleKeys.doNotDisturb: false])
        UserDefaults.standard.register(defaults: [SettingsBundleKeys.ringtones: "dog.mp3"])

    }

}

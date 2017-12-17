//
//  QuickbloxAdmin.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 13/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import Foundation

public struct QuickBloxAdmin {

    // MARK: Schema

    public static let accountKey = "accountKey"

    public static let applicationID = "applicationID"

    public static let authKey = "authKey"

    public static let authSecret = "authSecret"

}

enum QuickBloxAdminError: Error {

    case plistFileNotFound

    case invalidRootDictionary

    case invalidApplicationID

    case invalidAuthKey

    case invalidAuthSecret

    case invalidAccountKey

}

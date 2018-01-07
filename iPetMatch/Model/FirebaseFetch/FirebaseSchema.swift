//
//  FirebaseSchema.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 28/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import Foundation

enum FirebaseSchema: String {

    case users

    case likes

    case timeStamp

}

struct LikeMe {

    struct Schema {

        static let fromUserName = "fromUserName"
        static let fromUserImageURL = "fromUserImageURL"
        static let timestamp = "timestamp"

    }

    let fromUserName: String
    let fromUserImageURL: String
    let timestamp: Int

}

struct Like {

    struct Schema {

        static let fromID = "fromID"
        static let toID = "toID"
        static let timestamp = "timestamp"

    }

    let fromUser: IPetUser
    let timeStamp: Int

    static func getCurrentDate() -> Int {

        return  Int(Date().timeIntervalSince1970)

    }

}

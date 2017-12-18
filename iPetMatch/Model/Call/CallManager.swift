//
//  CallManager.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 14/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

class CallManager {

    static let shared = CallManager()

    // fromUser: User
    var fromUser: User?

    var toUserID: UInt?

    var conferenceType: QBRTCConferenceType = .audio

    var session: QBRTCSession?

    func makeCall(to userID: UInt, with conferenceType: QBRTCConferenceType) {

        let userID = userID as NSNumber

        var opponents = [NSNumber]()

        opponents.append(userID)

        let newSession = QBRTCClient.instance().createNewSession(withOpponents: opponents, with: conferenceType)

        let userInfo: [String: String] = ["key": "value"]

        newSession.startCall(userInfo)

        self.session = newSession

    }

}

// Call sounds
//extension CallManager {
//
//    static func startPlayingSound() {}
//
//    static func stopPlayingSound() {}
//
//}
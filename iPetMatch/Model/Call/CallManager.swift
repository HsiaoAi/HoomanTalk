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
    var toUserID: UInt?

    var conferenceType: QBRTCConferenceType = .audio

    var session: QBRTCSession?

    var userInfo: [String: String]?

    let audioManager = QBRTCAudioSession.instance()

    func makeCall(to userID: UInt, with conferenceType: QBRTCConferenceType) {

        let userID = userID as NSNumber

        var opponents = [NSNumber]()

        opponents.append(userID)

        let newSession = QBRTCClient.instance().createNewSession(withOpponents: opponents, with: conferenceType)

        newSession.startCall(userInfo)

        RingtonePlayer.shared.startPhoneRing(callRole: .host)

        self.session = newSession

    }

    func acceptCall() {

        CallManager.shared.session?.acceptCall(self.userInfo)

        RingtonePlayer.shared.stopPhoneRing()

    }

    func rejectCall(for session: QBRTCSession?) {

        session?.rejectCall(self.userInfo)

        RingtonePlayer.shared.stopPhoneRing()

    }

    func hangupCall() {

       RingtonePlayer.shared.stopPhoneRing()
        CallManager.shared.session?.hangUp(self.userInfo)

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

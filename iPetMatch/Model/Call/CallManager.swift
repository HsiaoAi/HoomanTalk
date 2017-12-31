//
//  CallManager.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 14/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//
protocol CallManagerProtocol: class {

    func didMakeCall(_ callManager: CallManager)
}

class CallManager {

    static let shared = CallManager()
    weak var delegate: CallManagerProtocol?

    // fromUser: User
    var fromId: String?

    var toId: String?

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

        let hostRef = Database.database().reference().child("user-friends").child(fromId!).child(toId!)

        let receiveRref = Database.database().reference().child("user-friends").child(toId!).child(fromId!)

        let callType = (conferenceType == .audio) ? "Audio Call" : "Video Call"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let timeZone = TimeZone(abbreviation: "CST")
        dateFormatter.timeZone = timeZone
        let dateString = dateFormatter.string(from: Date())

        let callInfo = [Friend.Schema.lastCallType: callType,
                        Friend.Schema.lastCallTime: dateString]
        hostRef.updateChildValues(callInfo)
        receiveRref.updateChildValues(callInfo)

        self.delegate?.didMakeCall(self)

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

    func startCountingTime(timerLabel: MZTimerLabel) {

        timerLabel.isHidden = false

        timerLabel.addTimeCounted(byTime: 0)

        timerLabel.start()

    }

    func stopCountingTime(timerLabel: MZTimerLabel) {

        timerLabel.pause()

    }

    func timerReset(timerLabel: MZTimerLabel) {

        timerLabel.reset()

        timerLabel.isHidden = true

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

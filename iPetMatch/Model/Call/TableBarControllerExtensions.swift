//
//  TableBarControllerExtensions.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 15/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

// Delegate to handel being called when someone started a new session with you.

extension TabBarController: QBRTCClientDelegate {

    // ReceiveCall

    func didReceiveNewSession(_ session: QBRTCSession, userInfo: [String: String]? = nil) {

        if CallManager.shared.session != nil {

            CallManager.shared.rejectCall(for: session)

        } else {
            CallManager.shared.userInfo = nil
            CallManager.shared.session = session
            CallManager.shared.userInfo = userInfo

            if self.isDoNotDisturb {
                CallManager.shared.rejectCall(for: session)
                return
            }

            RingtonePlayer.shared.startPhoneRing(callRole: .receiver)

            let incommingCallViewController = IncommingCallViewController()

            let incommingLabel = (session.conferenceType == .audio) ? NSLocalizedString("Incoming Audio Call", comment: "") :
                NSLocalizedString("Incoming Vedio Call", comment: "")
            incommingCallViewController.incommingType = incommingLabel
            self.present(incommingCallViewController, animated: true, completion: nil)

        }

    }

    @objc func defaultsChanged() {
        if let ringtoneName = UserDefaults.standard.object(forKey: SettingsBundleHelper.SettingsBundleKeys.ringtones) as? String {
            if let ringtoneEnum = RingtoneName(rawValue: ringtoneName) {
                RingtonePlayer.shared.ringtoneName = ringtoneEnum
            } else if let user = UserManager.instance.currentUser {
                RingtonePlayer.shared.ringtoneName = (user.petPersonType == .dog) ? RingtoneName.dog : RingtoneName.mewo
            }
        }

        self.isDoNotDisturb = UserDefaults.standard.bool(forKey: SettingsBundleHelper.SettingsBundleKeys.doNotDisturb)
    }

    func sessionDidClose(_ session: QBRTCSession) {

        print("***sessionDidClose***")

        CallManager.shared.session = nil
        CallManager.shared.userInfo = nil
        RingtonePlayer.shared.stopPhoneRing()
        self.dismiss(animated: false, completion: nil)

    }

    // Make Call

    func session(_ session: QBRTCSession, userDidNotRespond userID: NSNumber) {

        RingtonePlayer.shared.stopPhoneRing()

        print("***userDidNotRespond***")

    }

    func session(_ session: QBRTCSession, rejectedByUser userID: NSNumber, userInfo: [String: String]? = nil) {

        RingtonePlayer.shared.stopPhoneRing()

        print("***Reject***")

    }

    func session(_ session: QBRTCSession, acceptedByUser userID: NSNumber, userInfo: [String: String]? = nil) {

        RingtonePlayer.shared.stopPhoneRing()

        print("***acceptedByUser***")
    }

    func session(_ session: QBRTCSession, hungUpByUser userID: NSNumber, userInfo: [String: String]? = nil) {

        RingtonePlayer.shared.stopPhoneRing()

        print("***hungUpByUser***")

    }

    // Connection life-cyle

    func session(_ session: QBRTCBaseSession, startedConnectingToUser userID: NSNumber) {

        print("***startedConnectingToUser***")

    }

    func session(_ session: QBRTCBaseSession, connectedToUser userID: NSNumber) {

        print("***connectedToUser***")

    }

    func session(_ session: QBRTCBaseSession, connectionClosedForUser userID: NSNumber) {

        RingtonePlayer.shared.stopPhoneRing()
        print("***connectionClosedForUser***")

    }

    func session(_ session: QBRTCBaseSession, disconnectedFromUser userID: NSNumber) {

        RingtonePlayer.shared.stopPhoneRing()
        print("***disconnectedFromUser***")

    }

    func session(session: QBRTCSession!, userDidNotRespond userID: NSNumber!) {

        RingtonePlayer.shared.stopPhoneRing()
        print("***userDidNotRespond***")

    }

    func session(_ session: QBRTCBaseSession, connectionFailedForUser userID: NSNumber) {

        RingtonePlayer.shared.stopPhoneRing()
        print("***connectionFailedForUser***")

    }

    func session(_ session: QBRTCBaseSession, didChange state: QBRTCConnectionState, forUser userID: NSNumber) {
        if CallManager.shared.session != nil && state == .disconnected {

            CallManager.shared.session = nil

            self.dismiss(animated: false, completion: nil)

        }

    }

}

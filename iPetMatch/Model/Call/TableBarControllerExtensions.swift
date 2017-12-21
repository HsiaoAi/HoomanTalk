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

            CallManager.shared.session = session

            RingtonePlayer.shared.startPhoneRing(callRole: .receiver)

            switch session.conferenceType {

            case .audio:

                let incommingCallViewController = IncommingCallViewController()

                let navigationController = UINavigationController(rootViewController: incommingCallViewController)

                self.present(navigationController,
                             animated: true,
                             completion: nil)

            case .video:

                let incommingCallViewController = IncommingCallViewController()

               // let navigationController = UINavigationController(rootViewController: incommingCallViewController)

                self.present(incommingCallViewController, animated: true, completion: nil)
            }

        }

    }

    func sessionDidClose(_ session: QBRTCSession) {

        // TODO: show how long the call is
        print("***sessionDidClose***")

        CallManager.shared.session = nil

        RingtonePlayer.shared.stopPhoneRing()

        QBRTCAudioSession.instance().deinitialize()

    }

    // Make Call

    func session(_ session: QBRTCSession, userDidNotRespond userID: NSNumber) {

        // TODO: Show Alert

        RingtonePlayer.shared.stopPhoneRing()

        print("***userDidNotRespond***")

    }

    func session(_ session: QBRTCSession, rejectedByUser userID: NSNumber, userInfo: [String: String]? = nil) {

        RingtonePlayer.shared.stopPhoneRing()

        // TODO: Show Alerr
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

    // MARK - Connection life-cyle

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

        // TODO: Alert
        RingtonePlayer.shared.stopPhoneRing()
        print("***userDidNotRespond***")

    }

    func session(_ session: QBRTCBaseSession, connectionFailedForUser userID: NSNumber) {

        // TODO: Alert
        RingtonePlayer.shared.stopPhoneRing()
        print("***connectionFailedForUser***")

    }

}

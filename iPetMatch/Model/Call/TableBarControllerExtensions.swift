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

            let userInfo: [String: String] = ["key": "value"]

            session.rejectCall(userInfo)

        } else {

            CallManager.shared.session = session

            switch session.conferenceType {

            case .audio:

                let incommingCallViewController = IncommingCallViewController()

                let navigationController = UINavigationController(rootViewController: incommingCallViewController)

                self.present(navigationController, animated: true, completion: nil)

            case .video:

                let incommingCallViewController = IncommingCallViewController()

                let navigationController = UINavigationController(rootViewController: incommingCallViewController)

                self.present(navigationController, animated: true, completion: nil)
            }

        }

    }

    func sessionDidClose(_ session: QBRTCSession) {

        // TODO: show how long the call is
        print("***sessionDidClose***")

        CallManager.shared.session = nil

        self.dismiss(animated: true, completion: nil)

    }

    // Make Call

    func session(_ session: QBRTCSession, userDidNotRespond userID: NSNumber) {

        // TODO: Show Alert
        print("***userDidNotRespond***")

    }

    func session(_ session: QBRTCSession, rejectedByUser userID: NSNumber, userInfo: [String: String]? = nil) {

        // TODO: Show Alert
        print("***Reject***")

    }

    func session(_ session: QBRTCSession, acceptedByUser userID: NSNumber, userInfo: [String: String]? = nil) {

        print("***acceptedByUser***")
    }

    func session(_ session: QBRTCSession, hungUpByUser userID: NSNumber, userInfo: [String: String]? = nil) {

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

        print("***connectionClosedForUser***")

    }

    func session(_ session: QBRTCBaseSession, disconnectedFromUser userID: NSNumber) {

        print("***disconnectedFromUser***")

    }

    func session(session: QBRTCSession!, userDidNotRespond userID: NSNumber!) {

        // TODO: Alert
        print("***userDidNotRespond***")

    }

    func session(_ session: QBRTCBaseSession, connectionFailedForUser userID: NSNumber) {

        // TODO: Alert
        print("***connectionFailedForUser***")

    }

}

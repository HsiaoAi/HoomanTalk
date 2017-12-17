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

            self.present(IncommingCallViewController(), animated: true, completion: nil)

        }

    }

    func sessionDidClose(_ session: QBRTCSession) {

        // TODO: show how long the call is
        CallManager.shared.session = nil

    }

    // Make Call

    func session(_ session: QBRTCSession, userDidNotRespond userID: NSNumber) {

        // TODO: Show Alert
        print("----------userDidNotRespond")

    }

    func session(_ session: QBRTCSession, rejectedByUser userID: NSNumber, userInfo: [String: String]? = nil) {

        // TODO: Show Alert
        print("----------Reject")

        self.dismiss(animated: true, completion: nil)

    }

    func session(_ session: QBRTCSession, acceptedByUser userID: NSNumber, userInfo: [String: String]? = nil) {

        self.dismiss(

            animated: false,

            completion: {

                switch session.conferenceType {

                case .audio:
                    self.dismiss(animated: false, completion: {
                        print("here")
                        self.present(AudioCallingViewController(), animated: true, completion: nil)
                        
                        })

                case .video:

                    self.present(MakeCallViewController(), animated: true, completion: nil)
                }

            }

        )

    }

    func session(_ session: QBRTCSession, hungUpByUser userID: NSNumber, userInfo: [String: String]? = nil) {

        self.dismiss(animated: true, completion: nil)

    }

    // MARK - Connection life-cyle

    func session(_ session: QBRTCBaseSession, startedConnectingToUser userID: NSNumber) {

    }

    func session(_ session: QBRTCBaseSession, connectedToUser userID: NSNumber) {

    }

    func session(_ session: QBRTCBaseSession, connectionClosedForUser userID: NSNumber) {

        self.dismiss(animated: true, completion: nil)

    }

    func session(_ session: QBRTCBaseSession, disconnectedFromUser userID: NSNumber) {

        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    func session(session: QBRTCSession!, userDidNotRespond userID: NSNumber!) {

        // TODO: Alert
        print("----------User \(userID) did not respond to your call within timeout")
    }

    func session(_ session: QBRTCBaseSession, connectionFailedForUser userID: NSNumber) {

        // TODO: Alert
        print("----------Connection has failed with user \(userID)")

    }

}

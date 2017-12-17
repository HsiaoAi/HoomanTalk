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
}

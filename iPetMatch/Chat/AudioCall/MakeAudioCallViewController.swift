//
//  AudioCaliingViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 15/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class MakeAudioCallViewController: UIViewController {

    @IBOutlet weak var callStatusLabel: UILabel!

    @IBOutlet weak var declineButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        QBRTCClient.instance().add(self)
        
        callStatusLabel.text = "撥打語音電話中"

        declineButton.addTarget(self, action: #selector(declineCall), for: .touchUpInside)

    }

}

extension MakeAudioCallViewController: QBRTCClientDelegate {

    func session(_ session: QBRTCSession, acceptedByUser userID: NSNumber, userInfo: [String: String]? = nil) {

        callStatusLabel.text = "語音通話中"

    }

    func session(_ session: QBRTCSession, userDidNotRespond userID: NSNumber) {

        // TODO: Show Alert
        callStatusLabel.text = "語音沒有回應"

        self.dismiss(animated: true, completion: nil)

    }

    func session(_ session: QBRTCSession, rejectedByUser userID: NSNumber, userInfo: [String: String]? = nil) {

        // TODO: Show Alert
        callStatusLabel.text = "語音被拒絕"

        self.dismiss(animated: true, completion: nil)

    }

    func session(_ session: QBRTCSession, hungUpByUser userID: NSNumber, userInfo: [String: String]? = nil) {

        callStatusLabel.text = "語音通話結束"

        self.dismiss(animated: true, completion: nil)
    }

    func session(_ session: QBRTCBaseSession, connectionFailedForUser userID: NSNumber) {

        // TODO: Alert

        self.dismiss(animated: true, completion: nil)

        print("----------Connection has failed with user \(userID)")

    }
    
    func sessionDidClose(_ session: QBRTCSession) {
        print("***")
        // TODO: show how long the call is
        CallManager.shared.session = nil
        
    }

}

// Button funtions

extension MakeAudioCallViewController {

    @objc func declineCall() {

        let userInfo: [String: String] = ["key": "value"]

        CallManager.shared.session?.rejectCall(userInfo)

        CallManager.shared.session = nil

        self.dismiss(animated: true, completion: nil)

    }

}

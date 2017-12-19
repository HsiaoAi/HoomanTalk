//
//  IncommingCallViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 14/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class IncommingCallViewController: UIViewController {

    @IBOutlet weak var callStatusLabel: UILabel!

    var isAnswer = false

    override func viewDidLoad() {

        super.viewDidLoad()

        CallManager.shared.audioManager.currentAudioDevice = QBRTCAudioDevice.receiver

        QBRTCClient.instance().add(self)

        self.title = "來電"

    }

    @IBAction func answerCall(_ sender: Any) {

        isAnswer = true

        CallManager.shared.acceptCall()

        switch CallManager.shared.session!.conferenceType {

        case .audio:

            self.title = "通話中"

        case .video:

            self.present(MakeVideoCallViewController(), animated: false, completion: nil)

        }

    }

    @IBAction func declineCall(_ sender: Any) {

        let userInfo: [String: String] = ["key": "value"]

        if isAnswer {

            CallManager.shared.hangupCall()

        } else {

            CallManager.shared.rejectCall(for: CallManager.shared.session)

        }

    }

}

extension IncommingCallViewController: QBRTCClientDelegate {

    func session(_ session: QBRTCSession, hungUpByUser userID: NSNumber, userInfo: [String: String]? = nil) {

        CallManager.shared.hangupCall()

    }

    func sessionDidClose(_ session: QBRTCSession) {

        CallManager.shared.session = nil

        RingtonePlayer.shared.stopPhoneRing()

        self.dismiss(animated: true)

    }

}

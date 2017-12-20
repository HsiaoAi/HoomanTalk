//
//  AudioCaliingViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 15/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class MakeAudioCallViewController: UIViewController {

    @IBOutlet weak var timerLabel: MZTimerLabel!
    @IBOutlet weak var declineButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timerLabel.isHidden = true

        QBRTCClient.instance().add(self)

        CallManager.shared.audioManager.currentAudioDevice = QBRTCAudioDevice.receiver

        declineButton.addTarget(self, action: #selector(declineCall), for: .touchUpInside)

        self.navigationItem.title = "撥打語音電話中"

    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

    }

}

extension MakeAudioCallViewController: QBRTCClientDelegate {

    func session(_ session: QBRTCSession, acceptedByUser userID: NSNumber, userInfo: [String: String]? = nil) {

        self.navigationItem.title =  "通話中"

    }

    func session(_ session: QBRTCSession, rejectedByUser userID: NSNumber, userInfo: [String: String]? = nil) {

        self.navigationItem.title =  "被拒絕"

    }

    func session(_ session: QBRTCSession, hungUpByUser userID: NSNumber, userInfo: [String: String]? = nil) {

        print("++++++被掛斷++++++")

        self.navigationItem.title =  "被掛斷"

    }
    
    func session(_ session: QBRTCBaseSession, startedConnectingToUser userID: NSNumber) {
        
        CallManager.shared.startCountingTime(timerLabel: timerLabel)
        
    }
    
    func session(_ session: QBRTCBaseSession, disconnectedFromUser userID: NSNumber) {
        
        CallManager.shared.stopCountingTime(timerLabel: timerLabel)
        
    }
    
    func session(_ session: QBRTCBaseSession, connectionClosedForUser userID: NSNumber) {
        
        CallManager.shared.stopCountingTime(timerLabel: timerLabel)
        
    }


    func sessionDidClose(_ session: QBRTCSession) {

        RingtonePlayer.shared.stopPhoneRing()

        self.navigationItem.title = ""

        self.dismiss(animated: true, completion: nil)

    }

}

// Button funtions

extension MakeAudioCallViewController {

    @objc func declineCall() {

        let userInfo: [String: String] = ["key": "value"]

        CallManager.shared.session?.hangUp(userInfo)

        CallManager.shared.session = nil

    }

}

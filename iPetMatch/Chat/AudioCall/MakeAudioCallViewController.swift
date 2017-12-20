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

    @IBOutlet weak var callingToLabel: UILabel!

    @IBOutlet weak var speakerButton: LGButton!

    @IBOutlet weak var microphoneButton: LGButton!

    @IBAction func declineButton(_ sender: Any) {

        let userInfo: [String: String] = ["key": "value"]

        CallManager.shared.session?.hangUp(userInfo)

        CallManager.shared.session = nil

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.timerLabel.isHidden = true

        QBRTCClient.instance().add(self)

        CallManager.shared.audioManager.currentAudioDevice = QBRTCAudioDevice.receiver

        self.navigationController?.isNavigationBarHidden = true
    }
    @IBAction func switchSpeakerMode(_ sender: Any) {

        if CallManager.shared.audioManager.currentAudioDevice == .receiver {

            CallManager.shared.audioManager.currentAudioDevice = .speaker

            speakerButton.rightImageSrc = IconImage.speakerOn.image

        } else {

            CallManager.shared.audioManager.currentAudioDevice = .receiver

            speakerButton.rightImageSrc = IconImage.speakerOff.image

        }

    }

    @IBAction func switchMicrophoneMode(_ sender: Any) {

        if CallManager.shared.session!.localMediaStream.audioTrack.isEnabled {

            CallManager.shared.session!.localMediaStream.audioTrack.isEnabled = false

            microphoneButton.rightImageSrc = IconImage.microphoneOff.image

        } else {

            CallManager.shared.session!.localMediaStream.audioTrack.isEnabled = true

            microphoneButton.rightImageSrc = IconImage.microphoneOn.image

        }

    }
}

extension MakeAudioCallViewController: QBRTCClientDelegate {

    func session(_ session: QBRTCSession, acceptedByUser userID: NSNumber, userInfo: [String: String]? = nil) {

        callingToLabel.text = "Connecting..."

    }

    func session(_ session: QBRTCSession, rejectedByUser userID: NSNumber, userInfo: [String: String]? = nil) {

        callingToLabel.text = "Rejected By"

    }

    func session(_ session: QBRTCSession, hungUpByUser userID: NSNumber, userInfo: [String: String]? = nil) {

        print("++++++被掛斷++++++")

        callingToLabel.text = "Hang Up By"

    }

    func session(_ session: QBRTCBaseSession, connectedToUser userID: NSNumber) {

        callingToLabel.textColor = UIColor.clear

        timerLabel.isHidden = false

        CallManager.shared.startCountingTime(timerLabel: timerLabel)
    }

    func session(_ session: QBRTCBaseSession, startedConnectingToUser userID: NSNumber) {

    }

    func session(_ session: QBRTCBaseSession, disconnectedFromUser userID: NSNumber) {

        CallManager.shared.stopCountingTime(timerLabel: timerLabel)

    }

    func session(_ session: QBRTCBaseSession, connectionClosedForUser userID: NSNumber) {

        CallManager.shared.stopCountingTime(timerLabel: timerLabel)

    }

    func sessionDidClose(_ session: QBRTCSession) {

        RingtonePlayer.shared.stopPhoneRing()

        self.dismiss(animated: true, completion: nil)

    }

}

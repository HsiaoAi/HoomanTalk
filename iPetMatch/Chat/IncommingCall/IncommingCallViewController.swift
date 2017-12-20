//
//  IncommingCallViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 14/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class IncommingCallViewController: UIViewController {

    @IBOutlet weak var timerLabel: MZTimerLabel!

    @IBOutlet weak var userImageView: UIImageView!

    @IBOutlet weak var incomingCallLabel: UILabel!

    @IBOutlet weak var hostUserNameLabel: UILabel!

    @IBOutlet weak var beforeAnswerButtonsStack: UIStackView!

    @IBOutlet weak var afterAnswerBurronStack: UIStackView!

    @IBOutlet weak var speakerButton: LGButton!
    var isAnswer = false

    @IBOutlet weak var microphoneButton: LGButton!

    override func viewDidLoad() {

        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true

        timerLabel.isHidden = true

        afterAnswerBurronStack.isHidden = true

        QBRTCClient.instance().add(self)

    }

    override func viewDidDisappear(_ animated: Bool) {

        super.viewDidDisappear(animated)

        CallManager.shared.timerReset(timerLabel: timerLabel)

        // Rest microPhone
    }

    func turnOffSpeaker() {

        CallManager.shared.audioManager.currentAudioDevice = .receiver

        speakerButton.rightImageSrc = IconImage.speakerOff.image

    }

    @IBAction func switchMicrophone(_ sender: Any) {

        if CallManager.shared.session!.localMediaStream.audioTrack.isEnabled {

            CallManager.shared.session!.localMediaStream.audioTrack.isEnabled = false

            microphoneButton.rightImageSrc = IconImage.microphoneOff.image

        } else {

            CallManager.shared.session!.localMediaStream.audioTrack.isEnabled = true

            microphoneButton.rightImageSrc = IconImage.microphoneOn.image

        }

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

    @IBAction func answerCall(_ sender: Any) {

        isAnswer = true

        CallManager.shared.acceptCall()

        switch CallManager.shared.session!.conferenceType {

        case .audio:

            incomingCallLabel.text = "Connecting..."

            beforeAnswerButtonsStack.isHidden = true

            afterAnswerBurronStack.isHidden = false

            turnOffSpeaker()

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

    func session(_ session: QBRTCBaseSession, connectedToUser userID: NSNumber) {

        incomingCallLabel.textColor = UIColor.clear

        timerLabel.isHidden = false

        CallManager.shared.startCountingTime(timerLabel: timerLabel)
    }

    func session(_ session: QBRTCBaseSession, disconnectedFromUser userID: NSNumber) {

        CallManager.shared.stopCountingTime(timerLabel: timerLabel)

    }

    func session(_ session: QBRTCBaseSession, connectionClosedForUser userID: NSNumber) {

        CallManager.shared.stopCountingTime(timerLabel: timerLabel)

    }

    func session(_ session: QBRTCSession, hungUpByUser userID: NSNumber, userInfo: [String: String]? = nil) {

        CallManager.shared.hangupCall()

    }

    func sessionDidClose(_ session: QBRTCSession) {

        CallManager.shared.session = nil

        RingtonePlayer.shared.stopPhoneRing()

        self.dismiss(animated: false, completion: nil)

    }

}

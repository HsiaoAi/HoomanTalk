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
    @IBOutlet weak var friendImageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var incomingCallLabel: UILabel!
    @IBOutlet weak var hostUserNameLabel: UILabel!
    @IBOutlet weak var beforeAnswerButtonsStack: UIStackView!
    @IBOutlet weak var afterAnswerBurronStack: UIStackView!
    @IBOutlet weak var speakerButton: LGButton!

    var isAnswer = false
    var incommingType: String!
    let loadingImagesManager = LoadingImagesManager()

    @IBOutlet weak var microphoneButton: LGButton!

    @IBOutlet weak var audioSignImageView: UIImageView!

    override func viewDidLoad() {

        super.viewDidLoad()

        incomingCallLabel.text = incommingType

        self.navigationController?.isNavigationBarHidden = true

        timerLabel.isHidden = true

        afterAnswerBurronStack.isHidden = true

        setupAudioSignImageView()

        QBRTCClient.instance().add(self)

        setupFriendInfoView()

    }

    override func viewDidDisappear(_ animated: Bool) {

        super.viewDidDisappear(animated)

        CallManager.shared.timerReset(timerLabel: timerLabel)

    }

    func setupFriendInfoView() {

        guard let userInfo = CallManager.shared.userInfo else {
            SCLAlertView().showError(NSLocalizedString("Error", comment: ""), subTitle: NSLocalizedString("Unknown caller", comment: ""))
            return
        }

        hostUserNameLabel.text = userInfo[Friend.Schema.name]
        let imageAdress = userInfo[Friend.Schema.imageURL]
        loadingImagesManager.downloadAndCacheImage(urlString: imageAdress!, imageView: friendImageView, activityIndicatorView: nil, placeholderImage: nil)

    }

    func setupAudioSignImageView() {

        switch CallManager.shared.session!.conferenceType {

        case .audio:

            let path = Bundle.main.path(forResource: "AudioCall.gif", ofType: nil)!

            let url = URL(fileURLWithPath: path)

            audioSignImageView.sd_setImage(with: url, placeholderImage: nil)

        case .video:

            let path = Bundle.main.path(forResource: "VideoCall.gif", ofType: nil)!

            let url = URL(fileURLWithPath: path)

            audioSignImageView.sd_setImage(with: url, placeholderImage: nil)

        }

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

            incomingCallLabel.text = NSLocalizedString("Connecting...", comment: "")

            beforeAnswerButtonsStack.isHidden = true

            afterAnswerBurronStack.isHidden = false

            audioSignImageView.stopAnimating()

            turnOffSpeaker()

        case .video:
            let answerVideoCallViewController = MakeVideoCallViewController()
            self.present(answerVideoCallViewController, animated: false, completion: nil)

        }

    }

    @IBAction func declineCall(_ sender: Any) {

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

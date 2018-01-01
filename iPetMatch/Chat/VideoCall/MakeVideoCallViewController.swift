//
//  MakeCallViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 16/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class MakeVideoCallViewController: UIViewController {

    var videoCapture: QBRTCCameraCapture?

    var selectedFriend: Friend?

    @IBOutlet weak var localVideoView: LocalVideoView!

    @IBOutlet weak var controlPanelStackView: UIStackView!

    @IBOutlet weak var videoSignImageView: FLAnimatedImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!

    @IBOutlet weak var callingFromLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var opponentVideoView: QBRTCRemoteVideoView!

    @IBOutlet weak var timerLabel: MZTimerLabel!

    @IBAction func hangUpCall(_ sender: Any) {

        CallManager.shared.session?.hangUp(nil)

    }

    @IBOutlet weak var cameraPositionButton: LGButton!

    @IBAction func switchCameraPoistion(_ sender: Any) {

        if let position = self.videoCapture?.position {

            switch position {

            case .front:

                self.videoCapture?.position = .back

            case .back:

                self.videoCapture?.position = .front

            case .unspecified:

                self.videoCapture?.position = .front

            }
        }

    }

    @IBOutlet weak var cameraButton: LGButton!

    @IBAction func switchCameraEnabled(_ sender: Any) {

        if CallManager.shared.session!.localMediaStream.videoTrack.isEnabled {

            CallManager.shared.session!.localMediaStream.videoTrack.isEnabled = false

            self.localVideoView.isHidden = true

            cameraButton.rightImageSrc = IconImage.cameraOff.image

        } else {

            CallManager.shared.session!.localMediaStream.videoTrack.isEnabled = true

            self.localVideoView.isHidden = false

            cameraButton.rightImageSrc = IconImage.cameraOn.image

        }

    }

    @IBOutlet weak var microphoneButton: LGButton!

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

// View life cycle

extension MakeVideoCallViewController {

    override func viewDidLoad() {

        super.viewDidLoad()
        self.timerLabel.isHidden = true

        opponentVideoView.videoGravity = "AVLayerVideoGravityResizeAspect"

        CallManager.shared.audioManager.currentAudioDevice = QBRTCAudioDevice.speaker

        QBRTCClient.instance().add(self)
        setupVideoSignImageView()

        setupLocalVideoView()
        if CallManager.shared.session != nil {

            // Incomming

            guard let callingUser = CallManager.shared.userInfo else {
                SCLAlertView().showInfo(NSLocalizedString("Error", comment: ""), subTitle: NSLocalizedString("Friend end this call", comment: ""))
                return
            }
            callingFromLabel.text = NSLocalizedString("Video Call From", comment: "")
            userNameLabel.text = callingUser[Friend.Schema.name]
            let imageAdress = callingUser[Friend.Schema.imageURL]
            if let imageURL = URL(string: imageAdress!) {
                UserManager.setUserProfileImage(with: imageURL, into: self.userImageView, activityIndicatorView: self.activityIndicatorView)
            }
            self.prepareLocalVideoTrack()

        } else {

            // Make call
            guard let callToUser = self.selectedFriend,
                let callingID = callToUser.callingID as NSNumber? else {
                SCLAlertView().showInfo(NSLocalizedString("Error", comment: ""), subTitle: NSLocalizedString("Try again", comment: ""))
                self.dismiss(animated: false, completion: nil)
                return
            }

            CallManager.shared.session = QBRTCClient.instance().createNewSession(withOpponents: [callingID], with: .video)

            callingFromLabel.text = NSLocalizedString("Video Calling To", comment: "")
            userNameLabel.text = callToUser.name
            let imageAdress = callToUser.imageURL
            if let imageURL = URL(string: imageAdress!) {
                UserManager.setUserProfileImage(with: imageURL, into: self.userImageView, activityIndicatorView: self.activityIndicatorView)
            }

            self.prepareLocalVideoTrack()

            CallManager.shared.session?.startCall(nil)

            sendPushToOpponentsAboutNewCall()

            RingtonePlayer.shared.startPhoneRing(callRole: .host)

        }

    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        timerLabel.isHidden = true

    }

    func setupVideoSignImageView() {

        let path = Bundle.main.path(forResource: "VideoCall.gif", ofType: nil)!

        let url = URL(fileURLWithPath: path)

        videoSignImageView.sd_setImage(with: url, placeholderImage: nil)

    }

}

extension MakeVideoCallViewController: QBRTCClientDelegate {

    func prepareLocalVideoTrack() {

        let videoFormat = QBRTCVideoFormat.init()

        // QBRTCCameraCapture class used to capture frames using AVFoundation APIs
        self.videoCapture = QBRTCCameraCapture.init(videoFormat: videoFormat, position: AVCaptureDevice.Position.front)

        CallManager.shared.session?.localMediaStream.videoTrack.videoCapture = self.videoCapture

        self.videoCapture!.previewLayer.frame = self.localVideoView.bounds

        self.localVideoView.layer.insertSublayer(self.videoCapture!.previewLayer, at: 0)

        self.videoCapture!.startSession()
    }

    func session(_ session: QBRTCBaseSession, receivedRemoteVideoTrack videoTrack: QBRTCVideoTrack, fromUser userID: NSNumber) {

        RingtonePlayer.shared.stopPhoneRing()

        self.opponentVideoView.setVideoTrack(videoTrack)

    }

    func session(_ session: QBRTCBaseSession, connectedToUser userID: NSNumber) {

        timerLabel.isHidden = false
        CallManager.shared.startCountingTime(timerLabel: timerLabel)

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

        self.videoCapture?.stopSession()

    }

}

extension MakeVideoCallViewController: UIDropInteractionDelegate {

    func setupLocalVideoView() {

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))

        localVideoView.isUserInteractionEnabled = true

        localVideoView.addGestureRecognizer(panGesture)

    }

    @objc func draggedView(_ sender: UIPanGestureRecognizer) {

        self.view.bringSubview(toFront: localVideoView)
        let translation = sender.translation(in: self.view)
        let MinXCenter = localVideoView.bounds.width / 2
        let MaxXCenter = UIScreen.main.bounds.width - MinXCenter
        let MinYCenter = localVideoView.bounds.height / 2
        let MaxYCenter = UIScreen.main.bounds.height - MinYCenter
        let newXCenter = min(MaxXCenter, (max(localVideoView.center.x + translation.x, MinXCenter)))
        let newYCenter = min(MaxYCenter, (max(localVideoView.center.y + translation.y, MinYCenter)))
        localVideoView.center = CGPoint(x: newXCenter,
                                        y: newYCenter)
        sender.setTranslation(CGPoint.zero, in: self.view)

    }

}

// Push notification

extension MakeVideoCallViewController {

    func sendPushToOpponentsAboutNewCall() {

        var pushMessage = QBMPushMessage(payload: ["custom": "ilct23", "text": "Hello World !"])

        var userID = "38863883"

        QBRequest.sendPush(withText: "Video Call From ilct23",

                           toUsers: userID,

                           successBlock: {(_, _) -> Void in

                            print("+++Push Done")},

                           errorBlock: {(_ error: QBError) -> Void in

                            print("Push error \(error)")

        })
    }

}

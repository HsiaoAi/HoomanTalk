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

    @IBOutlet weak var localVideoView: LocalVideoView!

    @IBOutlet weak var controlPanelStackView: UIStackView!

    @IBOutlet weak var opponentVideoView: QBRTCRemoteVideoView!

    @IBOutlet weak var timerLabel: MZTimerLabel!

    @IBAction func hangUpCall(_ sender: Any) {

        let userInfo: [String: String] = ["key": "value"]

        CallManager.shared.session?.hangUp(userInfo)

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

            cameraButton.rightImageSrc = IconImage.cameraOff.image

        } else {

            CallManager.shared.session!.localMediaStream.videoTrack.isEnabled = true

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

        opponentVideoView.videoGravity = "AVLayerVideoGravityResizeAspect"

        CallManager.shared.audioManager.currentAudioDevice = QBRTCAudioDevice.speaker

        QBRTCClient.instance().add(self)

        setupLocalVideoView()

        if CallManager.shared.session != nil {

            // Incomming

            self.prepareLocalVideoTrack()

        } else {

            // Make call

            CallManager.shared.session = QBRTCClient.instance().createNewSession(withOpponents: [38863883], with: .video)

            self.prepareLocalVideoTrack()

            CallManager.shared.session?.startCall(nil)

            RingtonePlayer.shared.startPhoneRing(callRole: .host)

        }

    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        timerLabel.isHidden = true

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

        CallManager.shared.session = nil

        self.videoCapture?.stopSession()

        self.dismiss(animated: false, completion: nil)

        QBRTCAudioSession.instance().deinitialize()

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

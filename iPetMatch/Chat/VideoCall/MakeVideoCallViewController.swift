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

    @IBOutlet weak var makeCallResponseView: UIView!

    @IBOutlet weak var opponentVideoView: QBRTCRemoteVideoView!

    @IBAction func hangUpCall(_ sender: Any) {

        let userInfo: [String: String] = ["key": "value"]

        CallManager.shared.session?.hangUp(userInfo)

    }

}

// View life cycle

extension MakeVideoCallViewController {

    override func viewDidLoad() {

        super.viewDidLoad()

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

    override func viewDidDisappear(_ animated: Bool) {

        super.viewDidDisappear(animated)

    }

}

extension MakeVideoCallViewController: QBRTCClientDelegate {

    func prepareLocalVideoTrack() {

        let videoFormat = QBRTCVideoFormat.init()

        // QBRTCCameraCapture class used to capture frames using AVFoundation APIs
        self.videoCapture = QBRTCCameraCapture.init(videoFormat: videoFormat, position: AVCaptureDevice.Position.front)

        CallManager.shared.session?.localMediaStream.videoTrack.videoCapture = self.videoCapture

        self.videoCapture!.previewLayer.frame = self.localVideoView.bounds

        self.videoCapture!.startSession()

        self.localVideoView.layer.insertSublayer(self.videoCapture!.previewLayer, at: 0)

    }

    func session(_ session: QBRTCBaseSession, receivedRemoteVideoTrack videoTrack: QBRTCVideoTrack, fromUser userID: NSNumber) {

        RingtonePlayer.shared.stopPhoneRing()

        opponentVideoView.videoGravity = "AVLayerVideoGravityResizeAspect"

        opponentVideoView.setVideoTrack(videoTrack)

    }

    func sessionDidClose(session: QBRTCSession!) {

        CallManager.shared.session = nil

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

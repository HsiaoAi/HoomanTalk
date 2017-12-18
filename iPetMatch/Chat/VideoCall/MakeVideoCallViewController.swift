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

    @IBAction func hangUpCall(_ sender: Any) {

        let userInfo: [String: String] = ["key": "value"]

        CallManager.shared.session?.hangUp(userInfo)

    }
    @IBOutlet weak var opponentVideoView: QBRTCRemoteVideoView!

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

        }

    }

}

extension MakeVideoCallViewController: QBRTCClientDelegate {

    func prepareLocalVideoTrack() {

        let videoFormat = QBRTCVideoFormat.init()

        // QBRTCCameraCapture class used to capture frames using AVFoundation APIs
        self.videoCapture = QBRTCCameraCapture.init(videoFormat: videoFormat, position: AVCaptureDevice.Position.front)

        // add video capture to session's local media stream
        // from version 2.3 you no longer need to wait for 'initializedLocalMediaStream:' delegate to do it

        CallManager.shared.session?.localMediaStream.videoTrack.videoCapture = self.videoCapture

        self.videoCapture!.previewLayer.frame = self.localVideoView.bounds

        self.videoCapture!.startSession()

        self.localVideoView.layer.insertSublayer(self.videoCapture!.previewLayer, at: 0)

    }

    func session(_ session: QBRTCBaseSession, receivedRemoteVideoTrack videoTrack: QBRTCVideoTrack, fromUser userID: NSNumber) {

        print("+++++++++++++++")
        self.opponentVideoView.videoGravity = "AVLayerVideoGravityResizeAspect"
        self.opponentVideoView.setVideoTrack(videoTrack)

    }

    func sessionDidClose(session: QBRTCSession!) {

        CallManager.shared.session = nil

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

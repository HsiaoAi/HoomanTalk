//
//  MakeCallViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 16/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class MakeCallViewController: UIViewController {

    @IBOutlet weak var localVideoView: LocalVideoView!

    @IBAction func hangUpCall(_ sender: Any) {

        let userInfo: [String: String] = ["key": "value"]

        DispatchQueue.global().async {

            CallManager.shared.session?.hangUp(userInfo)

        }

    }

    @IBOutlet weak var opponentVideoView: QBRTCRemoteVideoView!
    override func viewDidLoad() {

        super.viewDidLoad()

        QBRTCClient.instance().add(self)

        setupLocalVideoView()

        self.opponentVideoView.backgroundColor = UIColor.white

        CallManager.shared.session = QBRTCClient.instance().createNewSession(withOpponents: [38863883], with: .video)

        CallManager.shared.prepareLocalVideoTrack(localVideoView: localVideoView)

        CallManager.shared.makeCall(to: 38863883, with: .video)

    }

}

extension MakeCallViewController: QBRTCClientDelegate {

    func session(session: QBRTCSession!, receivedRemoteVideoTrack videoTrack: QBRTCVideoTrack!, fromUser userID: NSNumber!) {

        self.opponentVideoView?.setVideoTrack(videoTrack)

    }

    func sessionDidClose(session: QBRTCSession!) {

        CallManager.shared.session = nil

        CallManager.shared.videoCapture?.stopSession(nil)

    }

}

extension MakeCallViewController: UIDropInteractionDelegate {

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

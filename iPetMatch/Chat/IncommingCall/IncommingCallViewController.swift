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

        QBRTCClient.instance().add(self)

        self.title = "來電"

    }

    @IBAction func answerCall(_ sender: Any) {

        isAnswer = true

        let userInfo: [String: String] = ["key": "value"]

        CallManager.shared.session?.acceptCall(userInfo)

        self.title = "通話中"

    }

    @IBAction func declineCall(_ sender: Any) {

        let userInfo: [String: String] = ["key": "value"]

        if isAnswer {

            CallManager.shared.session?.hangUp(userInfo)

        } else {

            CallManager.shared.session?.rejectCall(userInfo)

        }

    }

}

extension IncommingCallViewController: QBRTCClientDelegate {

    func session(_ session: QBRTCSession, hungUpByUser userID: NSNumber, userInfo: [String: String]? = nil) {

    }

    func sessionDidClose(_ session: QBRTCSession) {

        CallManager.shared.session = nil

        self.dismiss(animated: true)

    }

}

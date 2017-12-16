//
//  IncommingCallViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 14/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class IncommingCallViewController: UIViewController {

    @IBAction func answerCall(_ sender: Any) {

        let userInfo: [String: String] = ["key": "value"]

        CallManager.shared.session?.acceptCall(userInfo)

        let sessionConferenceType = CallManager.shared.session!.conferenceType

        switch sessionConferenceType {

            case .audio:

                self.present(AudioCallingViewController(), animated: false, completion: nil)

            case .video:

                self.present(MakeCallViewController(), animated: false, completion: nil)

        }

    }

    @IBAction func declineCall(_ sender: Any) {

        let userInfo: [String: String] = ["key": "value"]

        DispatchQueue.global().async {

            CallManager.shared.session?.hangUp(userInfo)

        }

        CallManager.shared.session = nil

        self.dismiss(animated: true)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.yellow

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

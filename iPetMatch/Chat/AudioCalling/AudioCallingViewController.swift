//
//  AudioCaliingViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 15/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class AudioCallingViewController: UIViewController {

    @IBOutlet weak var callStatusLabel: UILabel!

    @IBAction func declineCall(_ sender: UIButton) {

        let userInfo: [String: String] = ["key": "value"]

        DispatchQueue.global().async {

            CallManager.shared.session?.hangUp(userInfo)

        }
        CallManager.shared.session = nil

       self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

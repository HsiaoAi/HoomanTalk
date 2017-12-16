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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

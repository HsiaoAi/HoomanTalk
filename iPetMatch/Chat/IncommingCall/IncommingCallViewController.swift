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

    @IBAction func answerCall(_ sender: Any) {
        
        isAnswer = true

        let userInfo: [String: String] = ["key": "value"]

        CallManager.shared.session?.acceptCall(userInfo)

        let sessionConferenceType = CallManager.shared.session!.conferenceType

        switch sessionConferenceType {

            case .audio:
                print("here")
                //self.present(MakeAudioCallViewController(), animated: false, completion: nil)

            case .video:

                self.present(MakeVideoCallViewController(), animated: false, completion: nil)

        }

    }

    @IBAction func declineCall(_ sender: Any) {

        let userInfo: [String: String] = ["key": "value"]

        if isAnswer {
            
            CallManager.shared.session?.hangUp(userInfo)
            
        } else {
            
            CallManager.shared.session?.rejectCall(userInfo)

        }

        CallManager.shared.session = nil

        self.dismiss(animated: true)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        QBRTCClient.instance().add(self)

        callStatusLabel.text = "來電"
    }

}

extension IncommingCallViewController: QBRTCClientDelegate {
    
    func session(_ session: QBRTCSession, hungUpByUser userID: NSNumber, userInfo: [String: String]? = nil) {
        
        callStatusLabel.text = "語音通話結束"
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func session(_ session: QBRTCBaseSession, connectionFailedForUser userID: NSNumber) {
        
        // TODO: Alert
        
        callStatusLabel.text = "Connection has failed"

        
        self.dismiss(animated: true, completion: nil)
        
        print("----------Connection has failed with user \(userID)")
        
    }
    
    func session(session: QBRTCSession!, disconnectedFromUser userID: NSNumber!) {
        callStatusLabel.text = "disconnectedFromUser"

    }
    
    func sessionDidClose(_ session: QBRTCSession) {
        print("***")
        // TODO: show how long the call is
        CallManager.shared.session = nil
        
        self.dismiss(animated: true, completion: nil)
        
        callStatusLabel.text = "sessionDidClose"
    }
    
}

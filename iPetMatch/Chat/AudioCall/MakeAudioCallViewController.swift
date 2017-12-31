//
//  AudioCaliingViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 15/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class MakeAudioCallViewController: UIViewController {

    @IBOutlet weak var friendImageView: UIImageView!
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var acticityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var timerLabel: MZTimerLabel!
    @IBOutlet weak var callingToLabel: UILabel!
    @IBOutlet weak var speakerButton: LGButton!
    @IBOutlet weak var microphoneButton: LGButton!
    @IBOutlet weak var audioSignGifView: FLAnimatedImageView!
    var selectedFriend: Friend?
    @IBAction func declineButton(_ sender: Any) {

        let userInfo = CallManager.shared.userInfo
        CallManager.shared.session?.hangUp(userInfo)
        CallManager.shared.session = nil

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        connectQBChat()
        sendPushToOpponentsAboutNewCall()
        self.timerLabel.isHidden = true
        setupAudioSignImageView()
        setupCallInfoView()
        QBRTCClient.instance().add(self)
        CallManager.shared.audioManager.currentAudioDevice = QBRTCAudioDevice.receiver
        self.navigationController?.isNavigationBarHidden = true
    }

    func connectQBChat() {

        if QBChat.instance.isConnected == false {
            SVProgressHUD.show(withStatus: NSLocalizedString("Connecting...", comment: ""))
            UIApplication.shared.beginIgnoringInteractionEvents()

            guard let user = Auth.auth().currentUser else {
                SVProgressHUD.dismiss()
                UIApplication.shared.endIgnoringInteractionEvents()
                SCLAlertView().showError(NSLocalizedString("Error", comment: ""),
                                         subTitle: NSLocalizedString("Something wrong, please log in again", comment: ""))
                AppDelegate.shared.enterLandingView()
                // ToDo: AddLogout!
                return
            }

            if let email = user.email {
                QBRequest.logIn(withUserEmail: email,
                                password: user.uid,
                                successBlock: { (_, QBuser) in
                                    QBChat.instance.connect(with: QBuser, completion: { _ in
                                        SVProgressHUD.dismiss()
                                    })},
                                errorBlock: {_ in
                                    SVProgressHUD.dismiss()
                                    SCLAlertView().showError(NSLocalizedString("Error", comment: ""),
                                                             subTitle: NSLocalizedString("Something wrong, please log in again", comment: ""))
                                    AppDelegate.shared.enterLandingView()
                })
            }
        }
    }

    func setupCallInfoView() {

        guard let friend = self.selectedFriend else {
            SCLAlertView().showError(NSLocalizedString("Error", comment: ""), subTitle: NSLocalizedString("Friend can't answer the call", comment: ""))
            return
        }
        friendNameLabel.text = friend.name
        let imageAdress = friend.imageURL
        if let imageURL = URL(string: imageAdress!) {
            UserManager.setUserProfileImage(with: imageURL, into: self.friendImageView, activityIndicatorView: self.acticityIndicatorView)
        }
    }

    func setupAudioSignImageView() {

        let path = Bundle.main.path(forResource: "AudioCall.gif", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        audioSignGifView.sd_setImage(with: url, placeholderImage: nil)

    }

    @IBAction func switchSpeakerMode(_ sender: Any) {

        if CallManager.shared.audioManager.currentAudioDevice == .receiver {

            CallManager.shared.audioManager.currentAudioDevice = .speaker

            speakerButton.rightImageSrc = IconImage.speakerOn.image

        } else {

            CallManager.shared.audioManager.currentAudioDevice = .receiver

            speakerButton.rightImageSrc = IconImage.speakerOff.image

        }

    }

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

extension MakeAudioCallViewController: QBRTCClientDelegate {

    func session(_ session: QBRTCSession, acceptedByUser userID: NSNumber, userInfo: [String: String]? = nil) {

        callingToLabel.text = NSLocalizedString("Connecting...", comment: "")

    }

    func session(_ session: QBRTCSession, rejectedByUser userID: NSNumber, userInfo: [String: String]? = nil) {

        callingToLabel.text = NSLocalizedString("Rejected by friend", comment: "")

         SCLAlertView().showInfo("Information", subTitle: NSLocalizedString("Rejected by friend", comment: ""))

    }

    func session(_ session: QBRTCSession, hungUpByUser userID: NSNumber, userInfo: [String: String]? = nil) {

        print("++++++被掛斷++++++")

        callingToLabel.text = NSLocalizedString("Hang up by friend", comment: "")
        SCLAlertView().showInfo("Information", subTitle: NSLocalizedString("Hang up by friend", comment: ""))

    }

    func session(_ session: QBRTCBaseSession, connectedToUser userID: NSNumber) {

        callingToLabel.textColor = UIColor.clear
        timerLabel.isHidden = false
        callingToLabel.textColor = UIColor.clear
        audioSignGifView.stopAnimating()
        CallManager.shared.startCountingTime(timerLabel: timerLabel)
    }

    func session(_ session: QBRTCBaseSession, startedConnectingToUser userID: NSNumber) {

    }

    func session(_ session: QBRTCBaseSession, disconnectedFromUser userID: NSNumber) {

        CallManager.shared.stopCountingTime(timerLabel: timerLabel)

    }

    func session(_ session: QBRTCBaseSession, connectionClosedForUser userID: NSNumber) {

        CallManager.shared.stopCountingTime(timerLabel: timerLabel)

    }

    func sessionDidClose(_ session: QBRTCSession) {

        RingtonePlayer.shared.stopPhoneRing()

        self.dismiss(animated: false, completion: nil)

    }

    func session(_ session: QBRTCBaseSession, didChange state: QBRTCSessionState) {

        if state == .closed && CallManager.shared.session != nil {

            self.dismiss(animated: false, completion: nil)

        }

    }

}

// Push notification

extension MakeAudioCallViewController {

    func sendPushToOpponentsAboutNewCall() {

        guard let currentUser = UserManager.instance.currentUser,
            let userId = CallManager.shared.userInfo?[Friend.Schema.callingID]   else {
            return
        }

        QBRequest.sendPush(withText: NSLocalizedString("Audio Call From", comment: "") + " \(currentUser.name)",

                           toUsers: userId,

                           successBlock: {(_, _) -> Void in

                            print("+++Push Done")},

                           errorBlock: {(_ error: QBError) -> Void in

                            print("Push error \(error)")

        })
    }

}

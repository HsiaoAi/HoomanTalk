//
//  RingtonePlayer.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 19/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import Foundation

class RingtonePlayer {

    static let shared = RingtonePlayer()

    var ringtoneID: SystemSoundID = 0

    var ringSoundTimer: Timer?

    var ringtonePlayer: AVAudioPlayer?

    var ringtoneName: RingtoneName = .dog

    func startPhoneRing(callRole: CallRole) {

        let path = Bundle.main.path(forResource: ringtoneName.rawValue, ofType: nil)!

        let url = URL(fileURLWithPath: path) as CFURL

        AudioServicesCreateSystemSoundID(url, &ringtoneID)

        if self.ringSoundTimer == nil {

            ringSoundTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector:

                #selector(playRingtone(_:)), userInfo: callRole.rawValue, repeats: true)

        }

    }

    @objc func playRingtone(_ timer: Timer) {

        if let callRole = timer.userInfo as? Int, callRole == 1 {

            AudioServicesPlayAlertSound(self.ringtoneID)

            CallManager.shared.audioManager.currentAudioDevice = QBRTCAudioDevice.speaker

            if !UserSetting.isAllowVibrating {

                 AudioServicesPlaySystemSound(self.ringtoneID)

            }

        } else {

            AudioServicesPlaySystemSound(self.ringtoneID)

        }

    }

    func stopPhoneRing() {

        if self.ringSoundTimer != nil {

            ringSoundTimer?.invalidate()

            self.ringSoundTimer = nil

        }

    }

}

enum RingtoneName: String {

    case dog = "dog.mp3"

    case mewo = "Mewo.mp3"

}

enum CallRole: Int {

    case host

    case receiver

}

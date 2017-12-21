//
//  IconEnum.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 21/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import Foundation

enum IconImage {

    case landingImage

    case answerCall

    case endCall

    case speakerOn

    case speakerOff

    case microphoneOn

    case microphoneOff

    case cameraOff

    case cameraOn

}

extension IconImage {

    var image: UIImage {

        switch self {

        case .landingImage: return #imageLiteral(resourceName: "landingImage")

        case .answerCall: return  #imageLiteral(resourceName: "icon-answerCall")

        case .endCall: return #imageLiteral(resourceName: "icon-endPhone")

        case .speakerOn: return #imageLiteral(resourceName: "icon-speakerOn")

        case .speakerOff: return #imageLiteral(resourceName: "icon-speakerOff")

        case .microphoneOn: return #imageLiteral(resourceName: "icon-microphoneOn")

        case .microphoneOff: return #imageLiteral(resourceName: "icon-microphoneOff")

        case .cameraOn: return #imageLiteral(resourceName: "icon-cameraOn")

        case .cameraOff: return #imageLiteral(resourceName: "icon-cameraOff")

        }

    }

}

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

    case dogPerson

    case dogPersonSelected

    case catPerson

    case catPersonSelected

    case plus

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

        case .dogPerson: return #imageLiteral(resourceName: "dogPerson")

        case .dogPersonSelected: return #imageLiteral(resourceName: "dogPersonSelected")

        case .catPerson: return #imageLiteral(resourceName: "catPerson")

        case .catPersonSelected: return #imageLiteral(resourceName: "catPersionSelected")

        case .plus: return #imageLiteral(resourceName: "icon_plus")

        }

    }

}

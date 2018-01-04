//
//  TabBarItemType.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 15/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

enum TabBarItemType {

    case chat, match, pet, profile

}

extension TabBarItemType {

    var title: String {

        switch self {

        case .chat:

            return NSLocalizedString("Chat", comment: "")

        case .match:

            return NSLocalizedString("Match", comment: "")

        case .pet:

            return NSLocalizedString("Pets", comment: "")

        case .profile:

            return NSLocalizedString("Profile", comment: "")
        }
    }

    var image: UIImage {

        switch self {

        case .chat:

            return #imageLiteral(resourceName: "icon-caht").withRenderingMode(.alwaysTemplate)

        case .match:

            return #imageLiteral(resourceName: "icon-match").withRenderingMode(.alwaysTemplate)

        case .pet:

            return #imageLiteral(resourceName: "icon-pet").withRenderingMode(.alwaysTemplate)

        case .profile:

            return #imageLiteral(resourceName: "icon-profile") .withRenderingMode(.alwaysTemplate)

        }

    }

    var selectedImage: UIImage? {

        switch self {

        case .chat, .match, .pet, .profile:

            return nil

        }

    }

}

//
//  TabBarItemType.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 15/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

enum TabBarItemType {

    case chat, match, pet

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
        }
    }

    var image: UIImage {

        switch self {

        case .chat:

            return #imageLiteral(resourceName: "icon-chat").withRenderingMode(.alwaysTemplate)

        case .match:

            return #imageLiteral(resourceName: "icon-match").withRenderingMode(.alwaysTemplate)

        case .pet:

            return #imageLiteral(resourceName: "icon-pet").withRenderingMode(.alwaysTemplate)

        }

    }

    var selectedImage: UIImage? {

        switch self {

        case .chat, .match, .pet:

            return nil

        }

    }

}

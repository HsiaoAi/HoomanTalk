//
//  TabBarItemType.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 15/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

enum TabBarItemType {

    case chat

}

extension TabBarItemType {

    var title: String {

        switch self {

        case .chat:

            return NSLocalizedString("Chat", comment: "")

        }
    }

    var image: UIImage {

        switch self {

        case .chat:

            return #imageLiteral(resourceName: "icon-chat").withRenderingMode(.alwaysTemplate)

        }

    }

    var selectedImage: UIImage? {

        switch self {

        case .chat:

            return nil

        }

    }

}

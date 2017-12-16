//
//  TabBarItem.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 15/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

class TabBarItem: UITabBarItem {

    var itemType: TabBarItemType?

    init(itemType: TabBarItemType) {

        super.init()

        self.itemType = itemType

        self.title = itemType.title

        self.image = itemType.image

        self.selectedImage = itemType.selectedImage

    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

    }

}

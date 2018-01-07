//
//  LikedUsers+CoreDataProperties.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 30/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//
//

import Foundation
import CoreData

extension LikedUsers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LikedUsers> {
        return NSFetchRequest<LikedUsers>(entityName: "LikedUsers")
    }

    @NSManaged public var id: String?

}

//
//  Plant+CoreDataProperties.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 8/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//
//

import Foundation
import CoreData


extension Plant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plant> {
        return NSFetchRequest<Plant>(entityName: "Plant")
    }

    @NSManaged public var name: String?
    @NSManaged public var scientificName: String?
    @NSManaged public var yearDiscovered: Int32
    @NSManaged public var family: String?
    @NSManaged public var exhibition: Exhibition?

}

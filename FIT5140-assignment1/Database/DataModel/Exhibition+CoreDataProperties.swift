//
//  Exhibition+CoreDataProperties.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 17/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//
//

import Foundation
import CoreData


extension Exhibition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exhibition> {
        return NSFetchRequest<Exhibition>(entityName: "Exhibition")
    }

    @NSManaged public var desc: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var isGeoFenced: Bool
    @NSManaged public var plants: NSSet?

}

// MARK: Generated accessors for plants
extension Exhibition {

    @objc(addPlantsObject:)
    @NSManaged public func addToPlants(_ value: Plant)

    @objc(removePlantsObject:)
    @NSManaged public func removeFromPlants(_ value: Plant)

    @objc(addPlants:)
    @NSManaged public func addToPlants(_ values: NSSet)

    @objc(removePlants:)
    @NSManaged public func removeFromPlants(_ values: NSSet)

}

extension Exhibition : Identifiable {

}

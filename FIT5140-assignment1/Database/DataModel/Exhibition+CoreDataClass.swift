//
//  Exhibition+CoreDataClass.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 8/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Exhibition)
public class Exhibition: NSManagedObject,UIExhibition {
    var exhibitionPlants: [UIPlant] {
        var result = [UIPlant]()
        plants?.forEach({(plant) in
            if let plant = plant as? UIPlant{
                result.append(plant)
            }
        })
        return result
    }
}

//
//  UIExhibition.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 20/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import Foundation


protocol UIExhibition {
    var desc: String? {get}
    var imageUrl: String? {get}
    var latitude: Double {get}
    var longitude: Double {get}
    var name: String? {get}
    var subtitle: String? {get}
    var isGeoFenced: Bool {get}
    var exhibitionPlants: [UIPlant] {get}
}

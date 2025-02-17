//
//  UIExhibition.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 20/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import Foundation

//Protocol to represent the UI elements of Plant
protocol UIExhibition {
    var desc: String? {get}
    var imageUrl: String? {get}
    var latitude: Double {get}
    var longitude: Double {get}
    var name: String? {get}
    var subtitle: String? {get}
    var isGeoFenced: Bool {get}
    var exhibitionPlants: [UIPlant] {get}
    func toLocationAnnotation()->ExhibitsLocationAnnotation
}


struct UIExhibitionImpl:UIExhibition {

    
    var desc: String?
    
    var imageUrl: String?
    
    var latitude: Double
    
    var longitude: Double
    
    var name: String?
    
    var subtitle: String?
    
    var isGeoFenced: Bool
    
    var exhibitionPlants: [UIPlant]
    
    func toLocationAnnotation() -> ExhibitsLocationAnnotation {
        return ExhibitsLocationAnnotation(exhibition: self)
    }
    
}

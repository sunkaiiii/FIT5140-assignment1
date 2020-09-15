//
//  UIPlantProtocol.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 15/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import Foundation

protocol UIPlant {
    var name:String? { get  }
    var yearDiscovered:Int32 {get}
    var imageUrl:String? {get}
    var scientificName:String? {get}
    var family:String?{get}
    var isFromDatabase:Bool?{get}
}

struct UIPlantImpl:UIPlant{
    var name: String?
    
    var yearDiscovered: Int32
    
    var imageUrl: String?
    
    var scientificName: String?
    
    var family: String?
    
    var isFromDatabase: Bool?
    
    
}

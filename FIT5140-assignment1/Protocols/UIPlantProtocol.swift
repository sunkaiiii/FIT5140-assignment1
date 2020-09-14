//
//  UIPlantProtocol.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 15/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import Foundation

protocol UIPlantProtocol {
    var name:String? { get  }
    var yearDiscovered:Int32 {get}
    var imageUrl:String? {get}
    var scientificName:String? {get}
    var family:String?{get}
    var isFromDatabase:Bool?{get}
}

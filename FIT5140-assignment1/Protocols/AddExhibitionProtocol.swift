//
//  AddExhibitionProtocol.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 14/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import Foundation

protocol AddExhibitionProtocol:AnyObject{
    func addExhibition(name:String,subtitle:String,desc:String,latitude:Double,longitude:Double) -> Bool
}


protocol AddPlantProtocol:AnyObject{
    func addPlant(plant:UIPlant)->Bool
}

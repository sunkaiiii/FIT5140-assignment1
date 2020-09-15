//
//  EditPlantProtocol.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 15/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import Foundation

protocol EditPlantProtocol:AnyObject {
    func editPlant(newPlant:UIPlant)->Bool
}


protocol PlantListChangeListener:AnyObject{
    func onPlantListChanged()
}

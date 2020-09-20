//
//  DatabaseProtocol.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 30/8/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import Foundation

enum DatabaseChange{
    case add
    case remove
    case update
}

enum ListenerType{
    case exhibition
    case plant
    case all
}

protocol ExhibitionDatabaseListener:AnyObject{
    var listnerType:ListenerType{get set}
    func onExhibitionListChange(change:DatabaseChange,exhibitions:[Exhibition])
    func onPlantListChange(change:DatabaseChange, plants:[Plant])
}

protocol ExhibitionDatabaseProtocol:AnyObject{
    func addExhibition(name:String, subtitle:String,desc:String, latitude:Double, longitude:Double, imageUrl:String?, isGeoFenced:Bool)->Exhibition
    func addPlantToExhibition(plant:Plant,exhibition:Exhibition)->Bool
    func addPlant(name:String?, yearDiscovered:Int, family:String?, scientificName:String?, imageUrl:String?)->Plant
    func searchPlantByName(plantName:String)->[Plant]?
    func updatePlant(oldPlant:Plant, newPlant:UIPlant)->Plant?
    func updateExhibition(source:UIExhibition,targetExhibition:Exhibition)->Exhibition?
    func deletePlant(plant:Plant)
    func deleteExhibition(exhibition:Exhibition)
    func deletePlantFromExhibition(plant:Plant, exhibiton:Exhibition)
    func cleanup()
    func addListener(listener:ExhibitionDatabaseListener)
    func removeListener(listener:ExhibitionDatabaseListener)
}

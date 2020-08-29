//
//  PlantResponse.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 29/8/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import Foundation


public struct PlantList:Codable{
    public let data:[PlantResponse]
}

public struct PlantResponse:Codable{
    public let id:Int64
    public let commonName:String
    public let slug:String
    public let scientificName:String
    
    func toString()->String{
        return "\(id) \(commonName) \(slug) \(scientificName)"
    }
}

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

protocol DatabaseProtocol:AnyObject{
    func addExhibition(name:String, desc:String, latitude:Double, longitude:Double)->Exhibition
}

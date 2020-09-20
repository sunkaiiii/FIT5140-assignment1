//
//  LocationAnnotation.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 4/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit
import MapKit
class ExhibitsLocationAnnotation: NSObject, MKAnnotation {
    var coordinate:CLLocationCoordinate2D
    var title:String?
    var subtitle: String?
    var desc:String?
    var exhibition:UIExhibition?
    var geofence:CLCircularRegion?
    
    init(title:String?,subtitle:String?, desc:String?, latitude:Double, longitude: Double){
        self.title = title
        self.desc = desc
        self.subtitle = subtitle
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(exhibition:UIExhibition){
        self.title = exhibition.name
        self.desc = exhibition.desc
        self.subtitle = exhibition.subtitle
        self.coordinate = CLLocationCoordinate2DMake(exhibition.latitude, exhibition.longitude)
        self.exhibition = exhibition
    }
}

class ExhibitPlant{
    var plantName:String
    
    init(name:String) {
        self.plantName = name
    }
}

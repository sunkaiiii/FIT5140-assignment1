//
//  ExhibitLocationHelper.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 4/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import Foundation
import MapKit

func convertExhibitionsToAnnotations(exhibitons:[Exhibition])->[ExhibitsLocationAnnotation]{
    return exhibitons.map{(exhibition) in
        return ExhibitsLocationAnnotation(exhibition: exhibition)
    }
}

extension Exhibition{
    func toLocationAnnotation()->ExhibitsLocationAnnotation{
        return ExhibitsLocationAnnotation(exhibition: self)
    }
}

func moveToZoom(mapView:MKMapView, annotation:MKAnnotation){
    let zoomRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000,longitudinalMeters: 1000)
    mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
}

func selectAnnotationAndMoveToZoom(mapView:MKMapView,annotation:MKAnnotation){
    mapView.selectAnnotation(annotation, animated: true)
    moveToZoom(mapView: mapView, annotation: annotation)
}

extension MKMapView{
    func selectAnnotationAndMoveToFocus(_ annotation:MKAnnotation){
        selectAnnotationAndMoveToZoom(mapView: self, annotation: annotation)
    }
}

//Coordinate -> Placemark
func convertCoordinateToCurrentLocation(location:CLLocation,completionHandler: @escaping (CLPlacemark?) ->Void){
    let geocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
        if error == nil{
            let firstLocation = placemarks?[0]
            completionHandler(firstLocation)
        }else{
            completionHandler(nil)
        }
    })
}

//Address -> Placemark
func converAddressStringToCoordinate(addressString:String, completionHandler:@escaping ([CLPlacemark], NSError?)->Void){
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(addressString, in: nil, preferredLocale: nil, completionHandler: {(placemarks, error) in
        if error == nil{
                  if let placemarks = placemarks{
                      completionHandler(placemarks, nil)
                      return
                  }
              }
        completionHandler([],error as NSError?)
    })
}

extension CLPlacemark{
    func getFullAdress()->String{
        return "\(self.name ?? "") \(self.locality ?? "") \(self.administrativeArea ?? "") \(self.postalCode ?? "") \(self.country ?? "")"
    }
    
    func getCompatAddressWithState()->String{
        return "\(self.name ?? "") \(self.locality ?? "") \(self.administrativeArea ?? "")"
    }
    
    func getCompatAddress()->String{
        return "\(self.name ?? "") \(self.locality ?? "")"
    }
    
    func getStateAndCountry()->String{
        return "\(self.administrativeArea ?? "") \(self.postalCode ?? "") \(self.country ?? "")"
    }
}

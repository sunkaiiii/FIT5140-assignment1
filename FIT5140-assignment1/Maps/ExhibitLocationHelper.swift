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

func selectAnnotationAndMoveToZoom(mapView:MKMapView,annotation:MKAnnotation){
    mapView.selectAnnotation(annotation, animated: true)
    let zoomRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000,longitudinalMeters: 1000)
    mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
}

extension MKMapView{
    func selectAnnotationAndMoveToFocus(_ annotation:MKAnnotation){
        selectAnnotationAndMoveToZoom(mapView: self, annotation: annotation)
    }
}

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

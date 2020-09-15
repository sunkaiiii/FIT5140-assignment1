//
//  MapViewHelpter.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 15/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import Foundation
import MapKit

class MapViewHelper{
    static func generateCustomAnnotationView(mapView:MKMapView,annotation:ExhibitsLocationAnnotation)->MKAnnotationView?{
        return generateCustomAnnotation(mapView: mapView, annotation: annotation, imageUrl: annotation.exhibition?.imageUrl ?? "")
    }
    
    static func generateCustomAnnotation(mapView:MKMapView,annotation:MKAnnotation, imageUrl:String)->MKAnnotationView?{
        
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView:MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier){
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }else{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView{
            annotationView.canShowCallout = true
            if let image = UIImage(named: imageUrl){
                annotationView.image = image.resizeImage(newWidth: 40)?.circleMasked
            }else{
                ImageLoader.shraed.loadImage(imageUrl, onComplete: {(imageUrl,image) in
                    annotationView.image = image?.resizeImage(newWidth: 40)?.circleMasked
                })
            }
            
        }
        return annotationView
    }
}

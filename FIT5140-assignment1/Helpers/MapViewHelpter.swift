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
    
    static func generateCustomAnnotationView(mapView:MKMapView,annotation:ExhibitsLocationAnnotation, showRightIcon:Bool = false)->MKAnnotationView?{
        return generateCustomAnnotation(mapView: mapView, annotation: annotation, imageUrl: annotation.exhibition?.imageUrl ?? "", showRightIcon: showRightIcon)
    }
    
    //Create Custom style of AnnotationView
    static func generateCustomAnnotation(mapView:MKMapView,annotation:MKAnnotation, imageUrl:String, showRightIcon:Bool = false)->MKAnnotationView?{
        
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView:MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier){
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }else{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)

            
        }
        //if the annotation view is used in Home Page, this should show a arrow to indicate that the page navigation can happen when the annotation view is selected.
        if showRightIcon{
            let button = UIButton(type: .detailDisclosure)
            button.setImage(UIImage(named: "right arrow"), for: .normal)
            annotationView?.rightCalloutAccessoryView = button
        }else{
            annotationView?.rightCalloutAccessoryView = nil
        }
 
        if let annotationView = annotationView{
            annotationView.canShowCallout = true
            ImageLoader.simpleLoad(imageUrl, onComplete: {(imageUrl,image) in
                annotationView.image = image?.resizeImage(newWidth: 40)?.circleMasked
            })
//            if let image = UIImage(named: imageUrl){
//                annotationView.image = image.resizeImage(newWidth: 40)?.circleMasked
//            }else{
//                ImageLoader.shared.loadImage(imageUrl, onComplete: {(imageUrl,image) in
//                    annotationView.image = image?.resizeImage(newWidth: 40)?.circleMasked
//                })
//            }
            
        }
        return annotationView
    }
}

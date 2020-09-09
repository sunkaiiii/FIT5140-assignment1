//
//  ExhibitionDetailViewController.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 8/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit
import MapKit

class ExhibitionDetailViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var exhibitionImage: UIImageView!
    @IBOutlet weak var exhibitionName: UILabel!
    @IBOutlet weak var exhibitionLocation: UILabel!
    @IBOutlet weak var exhibitionDescription: UITextView!
    @IBOutlet weak var testLabel: UILabel!
    var annotation:ExhibitsLocationAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let annotation = annotation else {
            return
        }
        self.mapView.addAnnotation(annotation)
        selectAnnotation(mapView:mapView, annotation: annotation)
        self.title = annotation.title
        self.exhibitionName.text = annotation.title
        self.exhibitionImage.image = UIImage(named: annotation.title!)?.circleMasked?.addShadow(blurSize: 6)
        self.exhibitionDescription.text = annotation.desc
        let plant = annotation.exhibition?.plants?.first(where: {(plant)->Bool in return true }) as? Plant
        self.testLabel.text = plant?.name
        let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        convertCoordinateToCurrentLocation(location: location, completionHandler: {(placeMark) in
            guard let placeMark = placeMark else{
                return
            }
            self.exhibitionLocation.text = "\(placeMark.name ?? "") \(placeMark.thoroughfare ?? "") \(placeMark.locality ?? "") \(placeMark.postalCode ?? "") \(placeMark.country ?? "")"
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

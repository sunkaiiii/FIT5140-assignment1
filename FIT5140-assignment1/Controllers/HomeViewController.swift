//
//  HomeViewController.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 4/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit
import MapKit
class HomeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,MKMapViewDelegate,ExhibitionDatabaseListener {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    let allListSegue = "annotationToAllList"
    let exhibitionDetail = "exhibitionDetail"
    
    var exhibitionsAnnotations:[ExhibitsLocationAnnotation] = []
    weak var exhibitionController:ExhibitionDatabaseProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.mapView.delegate = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.exhibitionController = appDelegate.databaseController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        exhibitionController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        exhibitionController?.removeListener(listener: self)
    }
    
    func initExhibitions(exhibitions:[Exhibition]){
        exhibitionsAnnotations = convertExhibitionsToAnnotations(exhibitons: exhibitions)
        mapView.addAnnotations(exhibitionsAnnotations)
        if exhibitions.count>0{
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .bottom)
            let annotation = exhibitionsAnnotations[0]
            selectAnnotation(annotation: annotation)
        }
    }
    
    func onExhibitionListChange(change: DatabaseChange, exhibitions: [Exhibition]) {
        initExhibitions(exhibitions: exhibitions)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 1){
            return 1
        }
        return exhibitionsAnnotations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 1){
            return tableView.dequeueReusableCell(withIdentifier: "showAllCell", for: indexPath)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "exhibitCell", for: indexPath)
        let exhibit = exhibitionsAnnotations[indexPath.row]
        cell.textLabel?.text = exhibit.title
        cell.detailTextLabel?.text = "Lat:\(exhibit.coordinate.latitude) Long:\(exhibit.coordinate.longitude)\n\(exhibit.desc)"
        cell.detailTextLabel?.numberOfLines = 3
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0){
            let annotation = exhibitionsAnnotations[indexPath.row]
            selectAnnotation(annotation: annotation)
        }else{
            performSegue(withIdentifier: allListSegue, sender: nil)
        }
    }
    
    private func selectAnnotation(annotation:MKAnnotation){
        mapView.selectAnnotation(annotation, animated: true)
        let zoomRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000,longitudinalMeters: 1000)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
        
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
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
            annotationView.image = UIImage(named: annotation.title!!)?.resizeImage(newWidth: 40)?.circleMasked
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            performSegue(withIdentifier: exhibitionDetail, sender: view)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == allListSegue{
        }else if segue.identifier == exhibitionDetail{
            let controller = segue.destination as! ExhibitionDetailViewController
            let annotationView = sender as! MKAnnotationView
            controller.annotation = annotationView.annotation
        }
    }
}

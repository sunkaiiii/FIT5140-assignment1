//
//  HomeViewController.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 4/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit
import MapKit
class HomeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,MKMapViewDelegate,ExhibitionDatabaseListener,AddExhibitionProtocol {
    var listnerType: ListenerType = .exhibition

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    let allListSegue = "annotationToAllList"
    let exhibitionDetail = "exhibitionDetail"
    let addExhibitionSegue = "addExhibitionSegue"
    
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
        tableView.reloadData()
        if exhibitionsAnnotations.count > 0{
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .bottom)
            let annotation = exhibitionsAnnotations[0]
            selectAnnotationAndMoveToZoom(mapView: mapView,annotation: annotation)
        }
    }
    
    func onExhibitionListChange(change: DatabaseChange, exhibitions: [Exhibition]) {
        print(exhibitions.count)
        initExhibitions(exhibitions: exhibitions)
    }
    
    func onPlantListChange(change: DatabaseChange, plants: [Plant]) {}
    
    
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
        cell.detailTextLabel?.text = "Lat:\(exhibit.coordinate.latitude) Long:\(exhibit.coordinate.longitude)\n\(exhibit.desc ?? "")"
        cell.detailTextLabel?.numberOfLines = 3
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0){
            let annotation = exhibitionsAnnotations[indexPath.row]
            selectAnnotationAndMoveToZoom(mapView:mapView, annotation: annotation)
        }else{
            performSegue(withIdentifier: allListSegue, sender: nil)
        }
    }
    

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ExhibitsLocationAnnotation{
            return MapViewHelper.generateCustomAnnotationView(mapView: mapView, annotation: annotation)
        }
        return nil
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
            controller.annotation = annotationView.annotation as! ExhibitsLocationAnnotation
        }else if segue.identifier == addExhibitionSegue{
            let controller = segue.destination as! AddExhibitionViewController
            controller.addExhibitionDelegate = self
        }
    }

    
    func addExhibition(name: String, subtitle: String, desc: String, latitude: Double, longitude: Double,imageUrl:String?) -> Exhibition? {
        let exhibition = exhibitionController?.addExhibition(name: name, subtitle: subtitle, desc: desc, latitude: latitude, longitude: longitude, imageUrl: imageUrl)
        return exhibition
    }
    
    func addPlantToExhibition(plant: Plant, exhibition: Exhibition) -> Bool {
        return exhibitionController?.addPlantToExhibition(plant: plant, exhibition: exhibition) ?? false
    }
    
    func afterAdd(needRefreshData: Bool) {
        if needRefreshData{
            tableView.reloadData()
        }
    }
    
}

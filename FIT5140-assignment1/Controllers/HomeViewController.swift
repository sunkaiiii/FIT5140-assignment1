//
//  HomeViewController.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 4/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit
import MapKit
class HomeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,MKMapViewDelegate,ExhibitionDatabaseListener,AddExhibitionProtocol, ExhibitionSelectedProtocol {
    var listnerType: ListenerType = .exhibition

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundLocating: UISwitch!
    
    var firstShow = true
    var locationManager = CLLocationManager()
    
    let BACKGROUND_LOCATING_KEY = "background_location"
    let SECTION_EXHIBITION_LIST = 1
    let SECTION_ALL_EXHIBITION = 0
    let allListSegue = "annotationToAllList"
    let exhibitionDetail = "exhibitionDetail"
    let addExhibitionSegue = "addExhibitionSegue"
    var exhibitionsAnnotations:[ExhibitsLocationAnnotation] = []
    var exhibitions = [Exhibition]()
    var selectIndex:Array<ExhibitsLocationAnnotation>.Index?
    weak var exhibitionController:ExhibitionDatabaseProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.mapView.delegate = self
        self.backgroundLocating.isOn = UserDefaults.standard.bool(forKey: BACKGROUND_LOCATING_KEY)
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
    
    func initExhibitions(){
        if exhibitionsAnnotations.count > 0 {
            mapView.removeAnnotations(exhibitionsAnnotations)
        }
        exhibitionsAnnotations = convertExhibitionsToAnnotations(exhibitons: exhibitions)
        mapView.addAnnotations(exhibitionsAnnotations)
        initGeofences(annotations: exhibitionsAnnotations)
        tableView.reloadData()
        if exhibitionsAnnotations.count > 0 && firstShow{
            self.selectIndex = 0
            firstShow = false
            let annotation = exhibitionsAnnotations[0]
            selectAnnotationAndMoveToZoom(mapView: mapView, annotation: annotation)
            tableView.selectRow(at: IndexPath(row: 0, section: SECTION_EXHIBITION_LIST), animated: false, scrollPosition: .none)
            tableView.scrollToRow(at: IndexPath(item: 0, section: SECTION_ALL_EXHIBITION), at: .top, animated: true)
        }else if exhibitionsAnnotations.count > 0, let index = selectIndex{
            let indexPath = IndexPath(row: index, section: SECTION_EXHIBITION_LIST)
            selectAnnotationAndMoveToZoom(mapView: mapView,annotation: exhibitionsAnnotations[indexPath.row])
        }
    
    }
    
    private func initGeofences(annotations:[ExhibitsLocationAnnotation]){
        let status = CLLocationManager.authorizationStatus()
        if status == .denied{
            return
        }
        let backgroundLocating = UserDefaults.standard.bool(forKey: BACKGROUND_LOCATING_KEY)
        if (status == .notDetermined || status == .authorizedWhenInUse) && backgroundLocating{
            locationManager.requestAlwaysAuthorization()
        }else if status == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
        }
        if status == .authorizedAlways{
            NotificationHelper.requestNotificationPermission()
        }
        for annotation in annotations{
            if let oldGeofence = annotation.geofence {
                locationManager.stopMonitoring(for: oldGeofence)
                annotation.geofence = nil
            }
            
            if !(annotation.exhibition?.isGeoFenced ?? false){
                continue
            }
            let geofence = CLCircularRegion(center: annotation.coordinate, radius: 500, identifier: "\(annotation.title ?? "gofence") \(annotation.coordinate.latitude)")
            geofence.notifyOnEntry = true
            geofence.notifyOnEntry = true
            locationManager.startMonitoring(for: geofence)
            annotation.geofence = geofence
        }
    }
    
    func onExhibitionListChange(change: DatabaseChange, exhibitions: [Exhibition]) {
        print(exhibitions.count)
        if exhibitions.count != self.exhibitions.count || !exhibitions.elementsEqual(self.exhibitions){
            self.exhibitions = exhibitions
            initExhibitions()
        }
        
    }
    
    func onPlantListChange(change: DatabaseChange, plants: [Plant]) {}
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == SECTION_ALL_EXHIBITION){
            return 1
        }
        return exhibitionsAnnotations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == SECTION_ALL_EXHIBITION){
            return tableView.dequeueReusableCell(withIdentifier: "showAllCell", for: indexPath)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "exhibitCell", for: indexPath)
        let exhibit = exhibitionsAnnotations[indexPath.row]
        cell.textLabel?.text = exhibit.title
        cell.detailTextLabel?.text = "Lat:\(exhibit.coordinate.latitude) Long:\(exhibit.coordinate.longitude)\n\(exhibit.desc ?? "")"
        cell.detailTextLabel?.numberOfLines = 3
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == SECTION_EXHIBITION_LIST{
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == SECTION_EXHIBITION_LIST{
            let deleteIndex = indexPath.row
            if deleteIndex < selectIndex ?? -1{
                selectIndex! -= 1
            }else if deleteIndex == selectIndex ?? -1{
                selectIndex = 0
            }
            let exhibition = exhibitions[indexPath.row]
            if let annotation = findAnnotationByExhibition(exhibition: exhibition), let geofence = annotation.geofence{
                locationManager.stopMonitoring(for: geofence)
            }
            exhibitionController?.deleteExhibition(exhibition: exhibition)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == SECTION_EXHIBITION_LIST){
            selectIndex = indexPath.row
            let annotation = exhibitionsAnnotations[indexPath.row]
            selectAnnotationAndMoveToZoom(mapView:mapView, annotation: annotation)
        }else{
            performSegue(withIdentifier: allListSegue, sender: nil)
        }
    }
    
    
    func didSelectExhibition(exhibition: Exhibition) {
        if let index = exhibitionsAnnotations.firstIndex(where: {(annotation) in
            if let ex = annotation.exhibition as? Exhibition{
                return exhibition == ex
            }
            return false
        }){
            selectIndex = index
            tableView.selectRow(at: IndexPath(item: index, section: SECTION_EXHIBITION_LIST), animated: true, scrollPosition: .top)
            selectAnnotationAndMoveToZoom(mapView: mapView,annotation: exhibitionsAnnotations[index])
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let selectAnnotation = view.annotation as? ExhibitsLocationAnnotation,let index = exhibitionsAnnotations.firstIndex(where: {(annotation) in
            annotation == selectAnnotation
        }){
            selectIndex = index
            tableView.selectRow(at: IndexPath(item: index, section: SECTION_EXHIBITION_LIST), animated: true, scrollPosition: .top)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == allListSegue{
            let controller = segue.destination as! AllExhibitionTableViewController
            controller.exhibitionSelectedProtocol = self
        }else if segue.identifier == exhibitionDetail{
            let controller = segue.destination as! ExhibitionDetailViewController
            let annotationView = sender as! MKAnnotationView
            controller.annotation = annotationView.annotation as? ExhibitsLocationAnnotation
        }else if segue.identifier == addExhibitionSegue{
            let controller = segue.destination as! AddExhibitionViewController
            controller.addExhibitionDelegate = self
        }
    }

    
    func addExhibition(name: String, subtitle: String, desc: String, latitude: Double, longitude: Double,imageUrl:String?) -> Exhibition? {
        let exhibition = exhibitionController?.addExhibition(name: name, subtitle: subtitle, desc: desc, latitude: latitude, longitude: longitude, imageUrl: imageUrl,isGeoFenced: true)
        return exhibition
    }
    
    func addPlantToExhibition(plant: Plant, exhibition: Exhibition) -> Bool {
        return exhibitionController?.addPlantToExhibition(plant: plant, exhibition: exhibition) ?? false
    }
    
    func afterAdd(needRefreshData: Bool) {
        if needRefreshData{
            showToast(message: "Successfully added ")
            tableView.reloadData()
        }
    }
    
    private func findAnnotationByExhibition(exhibition:Exhibition)->ExhibitsLocationAnnotation?{
        return exhibitionsAnnotations.first(where: {(annotation) in
            if let ex = annotation.exhibition as? Exhibition{
                return exhibition == ex
            }
            return false
        })
    }
    
    @IBAction func OnSwitchValueChanged(_ sender: Any) {
        UserDefaults.standard.setValue(backgroundLocating.isOn, forKey: BACKGROUND_LOCATING_KEY)
        initGeofences(annotations: exhibitionsAnnotations)
    }
}

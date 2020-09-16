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
    
    var firstShow = true
    
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
        tableView.reloadData()
        if exhibitionsAnnotations.count > 0 && firstShow{
            self.selectIndex = 0
            firstShow = false
            let annotation = exhibitionsAnnotations[0]
            selectAnnotationAndMoveToZoom(mapView: mapView, annotation: annotation)
            tableView.selectRow(at: IndexPath(row: 0, section: SECTION_EXHIBITION_LIST), animated: false, scrollPosition: .none)
            tableView.scrollToRow(at: IndexPath(item: 0, section: SECTION_ALL_EXHIBITION), at: .top, animated: true)
        }else if let index = selectIndex{
            let indexPath = IndexPath(row: index, section: SECTION_EXHIBITION_LIST)
            selectAnnotationAndMoveToZoom(mapView: mapView,annotation: exhibitionsAnnotations[indexPath.row])
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == SECTION_EXHIBITION_LIST){
            let annotation = exhibitionsAnnotations[indexPath.row]
            selectAnnotationAndMoveToZoom(mapView:mapView, annotation: annotation)
        }else{
            performSegue(withIdentifier: allListSegue, sender: nil)
        }
    }
    
    
    func didSelectExhibition(exhibition: Exhibition) {
        if let index = exhibitionsAnnotations.firstIndex(where: {(annotation) in
            exhibition == annotation.exhibition
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

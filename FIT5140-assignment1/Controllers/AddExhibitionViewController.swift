//
//  AddExhibitionViewController.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 8/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit
import MapKit

class AddExhibitionViewController: UIViewController, UISearchBarDelegate,UITableViewDataSource, UITableViewDelegate,AddPlantProtocol, ImagePickerDelegate,MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var exhibitionName: UITextField!
    @IBOutlet weak var exhibitionDescription: UITextField!
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var exhibitionMapSelectionButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var selectImage: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var plantTableView: UITableView!
    @IBOutlet weak var useCurrentLocationButton: UIButton!
    var locationManager = CLLocationManager()
    var currentLocation:CLLocationCoordinate2D?
    
    let LOCATION_CELL = "locationCell"
    let ADD_PLANT_SEGUE = "addPlant"
    var locations = [CLPlacemark]()
    var selectedExhibition:ExhibitsLocationAnnotation?
    weak var addExhibitionDelegate:AddExhibitionProtocol?
    weak var exhibitionController:ExhibitionDatabaseProtocol?
    var plantTableViewDelegate:PlantTableViewDelegate?
    var icon:UIImage?
    var imageUrl:String?
    var imagePicker:ImagePicker?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.exhibitionController = appDelegate.databaseController
        imagePicker = ImagePicker(presentationController: self, delegate: self)

        // Do any additional setup after loading the view.
        locationSearchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        mapView.delegate = self
        exhibitionName.delegate  = self
        exhibitionDescription.delegate = self
        locationManager.delegate = self
        plantTableViewDelegate = PlantTableViewDelegate()
        plantTableView.delegate = plantTableViewDelegate
        plantTableView.dataSource = plantTableViewDelegate
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = locationSearchBar.text{
            searchBar.resignFirstResponder()
            searchBar.isUserInteractionEnabled = false
            mapView.removeAnnotations(mapView.annotations)
            mapView.isHidden = true
            tableView.isHidden = false
            locations = []
            tableView.reloadData()
            converAddressStringToCoordinate(addressString: searchText, completionHandler: {(placemarks,error) in
                if let error = error {
                    print(error)
                    return
                }
                searchBar.isUserInteractionEnabled = true
                self.locations = placemarks
                self.tableView.reloadData()

            })
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        useCurrentLocationButton.isHidden = searchBar.text?.count ?? 0 > 0
    }
    
    @IBAction func useCurrentLocation(_ sender: Any) {
        
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }else if status == .denied{
            showToast(message: "Location permission is denied, faied to get the current location")
            return
        }
        
        if let location = currentLocation{
            convertCoordinateToCurrentLocation(location: CLLocation(latitude: location.latitude, longitude: location.longitude), completionHandler: {(placeMark) in
                if let placeMark = placeMark{
                    self.locationSearchBar.text = "\(placeMark.locality ?? "") \(placeMark.country ?? "")"
                    self.useCurrentLocationButton.isHidden = true
                    self.setAnnotationToMapView(location: placeMark)
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            currentLocation = location.coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied{
            useCurrentLocationButton.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = locations[indexPath.row]
        setAnnotationToMapView(location: location)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LOCATION_CELL)!
        let location = locations[indexPath.row]
        cell.textLabel?.text = "\(location.name ?? "") \(location.thoroughfare ?? "")"
        cell.detailTextLabel?.text = "\(location.locality ?? "") \(location.postalCode ?? "") \(location.country ?? "")"
        return cell
    }
    
    @IBAction func addMapAnnotationIcon(_ sender: Any) {
        imagePicker?.present(from: sender as! UIView)
    }
    
    func didSelect(imageUrl: String, image: UIImage?) {
        guard let image = image else {
            return
        }
        self.imageUrl = imageUrl
        self.icon = image
        if let annotation = selectedExhibition{
            mapView.removeAnnotation(annotation)
            mapView.addAnnotation(annotation)
            mapView.selectAnnotationAndMoveToFocus(annotation)
        }
    }
    @IBAction func addExhibition(_ sender: Any) {
        if !checkValid(){
            var message:String = ""
            if selectedExhibition == nil{
                message += "You need to choose a exhibition location\n"
            }
            if plantTableViewDelegate?.plants.count ?? 0 < 3{
                message += "You need to choose at least 3 plants in the exhibition\n"
            }
            showAltert(title: "You need to fill all the requried information", message: message)
            return
        }
        
        if let exhibition = addExhibitionDelegate?.addExhibition(name: exhibitionName.text!, subtitle: exhibitionDescription.text!, desc: exhibitionDescription.text!, latitude: selectedExhibition!.coordinate.latitude, longitude: selectedExhibition!.coordinate.longitude,imageUrl:imageUrl){
            self.plantTableViewDelegate?.plants.forEach({(uiPlant) in
                if uiPlant.isFromDatabase ?? false, let existedPlant = uiPlant as? Plant{
                    let _ = self.addExhibitionDelegate?.addPlantToExhibition(plant: existedPlant, exhibition: exhibition)
                }else{
                    let newPlant = exhibitionController?.addPlant(name: uiPlant.name!, yearDiscovered: Int(uiPlant.yearDiscovered), family: uiPlant.family, scientificName: uiPlant.scientificName, imageUrl: uiPlant.imageUrl)
                    if let newPlant = newPlant{
                        let _ = self.addExhibitionDelegate?.addPlantToExhibition(plant: newPlant, exhibition: exhibition)
                    }
                }
            })
            self.addExhibitionDelegate?.afterAdd(needRefreshData: true)
            self.navigationController?.popViewController(animated: true)
        }else{
            //TODO altertController
        }
    }
    
    func checkValid()->Bool{
        if exhibitionName.text?.count == 0 || exhibitionDescription.text?.count == 0 || selectedExhibition == nil || plantTableViewDelegate?.plants.count ?? 0 < 3{
            return false
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ADD_PLANT_SEGUE{
            let controller = segue.destination as! AddPlantTableViewController
            controller.addPlantProtocol = self
        }
    }
    
    private func setAnnotationToMapView(location:CLPlacemark?){
        if let location = location, let coordinate = location.location?.coordinate{
            let annotation = ExhibitsLocationAnnotation(title: self.exhibitionName.text, subtitle: location.name ?? "", desc: self.exhibitionDescription.text, latitude: coordinate.latitude, longitude: coordinate.longitude)
            self.mapView.isHidden = false
            self.tableView.isHidden = true
            self.mapView.addAnnotation(annotation)
            self.selectedExhibition = annotation
            self.mapView.selectAnnotationAndMoveToFocus(annotation)
        }
    }
    
    func addPlant(plant: UIPlant) -> Bool {
        if plantTableViewDelegate?.plants.contains(where: {(p)->Bool in
            return plant.name == p.name && plant.scientificName == p.scientificName
        }) ?? false {
            return false
        }
        plantTableViewDelegate?.plants.append(plant)
        plantTableView.reloadData()
        return true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let imageUrl = imageUrl{
            return MapViewHelper.generateCustomAnnotation(mapView: mapView, annotation: annotation, imageUrl: imageUrl)
        }
        return nil
    }
}


class PlantTableViewDelegate:NSObject,UITableViewDataSource,UITableViewDelegate{
    var plants:[UIPlant] = []
    let SUMMARY_CELL = "summeriseCell"
    let PLANT_INFO_CELL = "plantInfoCell"
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return plants.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell?
        if indexPath.section == 0{
            cell = tableView.dequeueReusableCell(withIdentifier: SUMMARY_CELL, for: indexPath)
            cell?.textLabel?.text = "You have selected \(plants.count) plant(s)"
        }else if indexPath.section == 1{
            cell = tableView.dequeueReusableCell(withIdentifier: PLANT_INFO_CELL, for: indexPath)
            let plant = plants[indexPath.row]
            cell?.textLabel?.text = plant.name ?? ""
            cell?.detailTextLabel?.text = plant.scientificName ?? ""
        }else{
            cell = nil
        }
        return cell!
    }
}

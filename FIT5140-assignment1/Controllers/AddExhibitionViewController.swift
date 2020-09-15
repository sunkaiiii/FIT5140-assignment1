//
//  AddExhibitionViewController.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 8/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit
import MapKit

class AddExhibitionViewController: UIViewController, UISearchBarDelegate,UITableViewDataSource, UITableViewDelegate,AddPlantProtocol {

    @IBOutlet weak var exhibitionName: UITextField!
    @IBOutlet weak var exhibitionDescription: UITextField!
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var exhibitionMapSelectionButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var selectImage: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var plantTableView: UITableView!
    
    let LOCATION_CELL = "locationCell"
    let ADD_PLANT_SEGUE = "addPlant"
    var locations = [CLPlacemark]()
    var selectedExhibition:ExhibitsLocationAnnotation?
    weak var addExhibitionDelegate:AddExhibitionProtocol?
    weak var exhibitionController:ExhibitionDatabaseProtocol?
    var plantTableViewDelegate:PlantTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.exhibitionController = appDelegate.databaseController

        // Do any additional setup after loading the view.
        locationSearchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        plantTableViewDelegate = PlantTableViewDelegate()
        plantTableView.delegate = plantTableViewDelegate
        plantTableView.dataSource = plantTableViewDelegate
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = locationSearchBar.text{
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = locations[indexPath.row]
        let coordinate = location.location?.coordinate
        if let coordinate = coordinate{
            let annotation = ExhibitsLocationAnnotation(title: self.exhibitionName.text, subtitle: "\(location.name ?? "") \(location.thoroughfare ?? "")", desc: self.exhibitionDescription.text, latitude: coordinate.latitude, longitude: coordinate.longitude)
            self.mapView.isHidden = false
            self.tableView.isHidden = true
            self.mapView.addAnnotation(annotation)
            self.selectedExhibition = annotation
            self.mapView.selectAnnotationAndMoveToFocus(annotation)
        }
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
    

    @IBAction func addExhibition(_ sender: Any) {
        if !checkValid(){
            return
        }
        
        if addExhibitionDelegate?.addExhibition(name: exhibitionName.text!, subtitle: exhibitionDescription.text!, desc: exhibitionDescription.text!, latitude: selectedExhibition!.coordinate.latitude, longitude: selectedExhibition!.coordinate.longitude) ?? false{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func checkValid()->Bool{
        if exhibitionName.text?.count == 0 || exhibitionDescription.text?.count == 0 || selectedExhibition == nil{
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
    
    func addPlant(plant: UIPlant) -> Bool {
        if plantTableViewDelegate?.plants.contains(where: {(p)->Bool in
            return plant.name == p.name && plant.scientificName == p.scientificName
        }) ?? false {
            return false
        }
        
        if !(plant.isFromDatabase ?? false){
            let newPlant = exhibitionController?.addPlant(name: plant.name!, yearDiscovered: Int(plant.yearDiscovered), family: plant.family, scientificName: plant.scientificName, imageUrl: plant.imageUrl)
            if newPlant == nil{
                return false
            }
        }
        plantTableViewDelegate?.plants.append(plant)
        plantTableView.reloadData()
        return true
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

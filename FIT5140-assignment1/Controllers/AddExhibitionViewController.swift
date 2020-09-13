//
//  AddExhibitionViewController.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 8/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit
import MapKit

class AddExhibitionViewController: UIViewController, UISearchBarDelegate,UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var exhibitionName: UITextField!
    @IBOutlet weak var exhibitionDescription: UITextField!
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var exhibitionMapSelectionButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var selectImage: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let LOCATION_CELL = "locationCell"
    var locations = [CLPlacemark]()
    
    var selectedExhibition:ExhibitsLocationAnnotation?
    weak var addExhibitionDelegate:AddExhibitionProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationSearchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

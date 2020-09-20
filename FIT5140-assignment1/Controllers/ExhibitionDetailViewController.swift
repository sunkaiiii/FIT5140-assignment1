//
//  ExhibitionDetailViewController.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 8/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit
import MapKit

class ExhibitionDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate,EditExhibitionProtocol,PlantListChangeListener {
    let EXHIBITION_INFORMATION = 0
    let EXHIBITION_PLANT = 1
    let EXHIBITION_INFORMATION_CELL = "exhibitionInformation"
    let EXHIBITION_PLANT_CELL = "exhibitionPlant"
    let EXHIBITION_PLANT_DETAIL_SEGUE = "showPlantDetail"
    let EDIT_EXHIBITION_SEGUE = "editExhibition"
    weak var exhibitionController:ExhibitionDatabaseProtocol?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var exhibitionImage: UIImageView!
    var annotation:ExhibitsLocationAnnotation?
    var plants:[Plant]?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.exhibitionController = appDelegate.databaseController
        self.tableView.dataSource = self
        self.tableView.delegate = self
        fillDataToView()
    }
    
    private func fillDataToView(){
        guard let annotation = annotation else {
            return
        }
        plants = annotation.exhibition?.exhibitionPlants.map({(plant)->Plant in
            return plant as! Plant
        })
        plants?.sort(by: {(p1,p2)->Bool in
            p1.name?.lowercased() ?? "" < p2.name?.lowercased() ?? ""
        })
        self.mapView.delegate = self
        self.mapView.removeAnnotation(annotation)
        self.mapView.addAnnotation(annotation)
        selectAnnotationAndMoveToZoom(mapView:mapView, annotation: annotation)
        self.title = annotation.title
        if let imageUrl = annotation.exhibition?.imageUrl{
            ImageLoader.shared.loadImage(imageUrl, onComplete: {(imageUrl, image) in
                self.exhibitionImage.image = image?.circleMasked?.addShadow()
            })
        }
        tableView.reloadSections([EXHIBITION_INFORMATION], with: .automatic)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == EXHIBITION_INFORMATION{
            return 1
        }
        return plants?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell
        if indexPath.section == EXHIBITION_INFORMATION{
            let reuseCell = tableView.dequeueReusableCell(withIdentifier: EXHIBITION_INFORMATION_CELL,for: indexPath) as! ExhibitionDetailTableViewCell
            if let exhibition = annotation?.exhibition {
                reuseCell.showExhibitionDetail(exhibition)
            }
            cell = reuseCell
        }else{
            let reuseCell = tableView.dequeueReusableCell(withIdentifier: EXHIBITION_PLANT_CELL,for: indexPath) as! ExhibitionPlantTableViewCell
            if let plant = plants?[indexPath.row] {
                reuseCell.showPlantDetail(plant)
            }
            cell = reuseCell
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == EXHIBITION_PLANT, let plant = plants?[indexPath.row]{
            performSegue(withIdentifier: EXHIBITION_PLANT_DETAIL_SEGUE, sender: plant)
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == EXHIBITION_PLANT_DETAIL_SEGUE{
            if let controller = segue.destination as? PlantDetailViewController, let plant = sender as? Plant{
                controller.plant = plant
                controller.plantChangeListener = self
            }
        }else if segue.identifier == EDIT_EXHIBITION_SEGUE{
            if let controller = segue.destination as? EditExhibitionViewController, let exhibition = annotation{
                controller.exhibitionLocationAnnotation = exhibition.exhibition?.toLocationAnnotation()
                controller.editExhibitionDelegate = self
            }
        }
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ExhibitsLocationAnnotation{
            return MapViewHelper.generateCustomAnnotationView(mapView: mapView, annotation: annotation)
        }
        return nil
    }
    
    func editExhibition(source: UIExhibition)->Bool {
        if let exhibition = annotation?.exhibition as? Exhibition{
            let result = self.exhibitionController?.updateExhibition(source: source, targetExhibition: exhibition)
            if result != nil{
                self.annotation = exhibition.toLocationAnnotation()
                showToast(message: "Update Successfully")
                fillDataToView()
            }
            return result != nil
        }
        return false
    }
    
    func onPlantListChanged() {
        tableView.reloadSections([EXHIBITION_PLANT], with: .automatic)
    }
}

//
//  ExhibitionDetailViewController.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 8/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit
import MapKit

class ExhibitionDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let EXHIBITION_INFORMATION = 0
    let EXHIBITION_PLANT = 1
    let EXHIBITION_INFORMATION_CELL = "exhibitionInformation"
    let EXHIBITION_PLANT_CELL = "exhibitionPlant"
    let EXHIBITION_PLANT_DETAIL_SEGUE = "showPlantDetail"
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var exhibitionImage: UIImageView!
    var annotation:ExhibitsLocationAnnotation?
    var exhibition:Exhibition?
    var plants:[Plant]?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let annotation = annotation else {
            return
        }
        exhibition = annotation.exhibition
        plants = exhibition?.plants?.map({(plant)->Plant in
            return plant as! Plant
        })
        self.mapView.addAnnotation(annotation)
        selectAnnotationAndMoveToZoom(mapView:mapView, annotation: annotation)
        self.title = annotation.title
        self.exhibitionImage.image = UIImage(named: annotation.title!)?.circleMasked?.addShadow(blurSize: 6)
        self.tableView.dataSource = self
        self.tableView.delegate = self
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
            if let annotation = annotation {
                reuseCell.showExhibitionDetail(annotation)
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
            }
        }
    }


}

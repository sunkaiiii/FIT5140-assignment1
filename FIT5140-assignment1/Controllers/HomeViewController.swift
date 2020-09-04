//
//  HomeViewController.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 4/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit
import MapKit
class HomeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    var exhibitions:[ExhibitsLocationAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        initExhibitions()
    }
    
    func initExhibitions(){
        exhibitions = createDefaultExhibits()
        mapView.addAnnotations(exhibitions)
        if exhibitions.count>0{
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .bottom)
            let annotation = exhibitions[0]
            selectAnnotation(annotation: annotation)
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exhibitions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exhibitCell", for: indexPath)
        let exhibit = exhibitions[indexPath.row]
        cell.textLabel?.text = exhibit.title
        cell.detailTextLabel?.text = "Lat:\(exhibit.coordinate.latitude) Long:\(exhibit.coordinate.longitude)\n\(exhibit.desc)"
        cell.detailTextLabel?.numberOfLines = 3
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let annotation = exhibitions[indexPath.row]
        selectAnnotation(annotation: annotation)
    }
    
    private func selectAnnotation(annotation:MKAnnotation){
        mapView.selectAnnotation(annotation, animated: true)
        let zoomRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000,longitudinalMeters: 1000)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
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

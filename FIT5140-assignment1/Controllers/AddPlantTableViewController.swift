//
//  AddPlantTableViewController.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 14/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit

class AddPlantTableViewController: UITableViewController, UISearchBarDelegate,HTTPRequestAction {

    private let PLANT_CELL = "plantCell"
    
    weak var exhibitionDatabaseController:ExhibitionDatabaseProtocol?
    weak var addPlantProtocol:AddPlantProtocol?
    
    var allPlant = [UIPlant]()
    var indicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        exhibitionDatabaseController = appDelegate.databaseController
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Plants"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        definesPresentationContext = true
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPlant.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PLANT_CELL)!
        let plant = allPlant[indexPath.row]
        cell.textLabel?.text = plant.name
        cell.detailTextLabel?.text = plant.scientificName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let plant = allPlant[indexPath.row]
        let result = self.addPlantProtocol?.addPlant(plant: plant)
        if result ?? false{
            self.navigationController?.popViewController(animated: true)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, searchText.count>0 else {
            return
        }

        
        let result:[Plant]? = exhibitionDatabaseController?.searchPlantByName(plantName: searchText)
        guard let plants = result, plants.count > 0  else{
            requestRestfulService(api: PlantRequestAPI.searchPlant, model: SearchPlantRequest(searchText: searchText))
            return
        }
        
        allPlant = plants.map({(plant)->PlantResponse in plant.toPlantResponseModel()})
        tableView.reloadData()
    }
    
    func beforeExecution(helper: RequestHelper) {
        guard let api = helper.restfulAPI as? PlantRequestAPI else{
            return
        }
        switch api {
        case .searchPlant:
            indicator.startAnimating()
            indicator.backgroundColor = UIColor.clear
            allPlant.removeAll()
            tableView.reloadData()
        default:
            return
        }
    }
    
    func executionFailed(helper: RequestHelper, message: String, error: Error) {
        print(error)
    }
    
    func afterExecution(helper: RequestHelper, response: Data) {
        guard let api = helper.restfulAPI as? PlantRequestAPI else {
            return
        }
        switch api {
        case .searchPlant:
            fillTableView(response)
        default:
            return
        }
    }
    
    private func fillTableView(_ response:Data){
        do{
            let decoder = JSONDecoder()
            let plantData = try decoder.decode(SearchPlantResponse.self, from: response)
            let plants = plantData
            self.allPlant.append(contentsOf: plants.data)
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
            self.tableView.reloadData()
        }catch let error{
            print(error)
        }
    }
}

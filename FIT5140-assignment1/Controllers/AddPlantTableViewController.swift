//
//  AddPlantTableViewController.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 14/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit

class AddPlantTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate,HTTPRequestAction {

    private let PLANT_CELL = "plantCell"
    
    @IBOutlet weak var tableView: UITableView!
    weak var exhibitionDatabaseController:ExhibitionDatabaseProtocol?
    weak var addPlantProtocol:AddPlantProtocol?
    
    var allPlant = [UIPlant]()
    var indicator = UIActivityIndicatorView()
    var response:SearchPlantResponse?
    var request:SearchPlantRequest?
    var page = 1
    var isLoading = false
    var last:String?

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
        
        tableView.delegate = self
        tableView.dataSource = self
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        
        definesPresentationContext = true
        
    }
    

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPlant.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PLANT_CELL) as! SearchPlantTableViewCell
        let plant = allPlant[indexPath.row]
        cell.fillDataIntoView(plant: plant)
        if indexPath.row + 3 > allPlant.count && response != nil{
            self.request?.page = page+1
            page += 1
            if let request = request, !isLoading {
                requestRestfulService(api: PlantRequestAPI.searchPlant, model: request)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let plant = allPlant[indexPath.row]
        let result = self.addPlantProtocol?.addPlant(plant: plant)
        if result ?? false{
            self.navigationController?.popViewController(animated: true)
        }else{
            showAltert(title: "Duplicated plant", message: "You have chosen duplicated plant")
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, searchText.count>0 else {
            return
        }
        response = nil
        page = 1
        searchBar.resignFirstResponder()
        let result:[Plant]? = exhibitionDatabaseController?.searchPlantByName(plantName: searchText)
        guard let plants = result, plants.count > 0 && searchText != last  else{
            last = searchText
            request = SearchPlantRequest(searchText: searchText,page: page)
            requestRestfulService(api: PlantRequestAPI.searchPlant, model: request!)
            page+=1
            return
        }
        last = searchText
        allPlant = plants.map({(plant)->PlantResponse in plant.toPlantResponseModel()})
        tableView.reloadData()
        showToast(message: "Seach locally, Press Search Again to see the online result")
    }
    
    func beforeExecution(helper: RequestHelper) {
        guard let api = helper.restfulAPI as? PlantRequestAPI else{
            return
        }
        
        isLoading = true
        switch api {
        case .searchPlant:
            if page == 1{
                indicator.startAnimating()
                indicator.backgroundColor = UIColor.clear
                allPlant.removeAll()
            }
            tableView.reloadSections([0], with: .automatic)
            break
        }
    }
    
    func executionFailed(helper: RequestHelper, message: String, error: Error) {
        print(error)
    }
    
    func afterExecution(helper: RequestHelper,url:URLComponents, response: Data) {
        isLoading = false
        guard let api = helper.restfulAPI as? PlantRequestAPI else {
            return
        }
        switch api {
        case .searchPlant:
            fillTableView(response)
            break
        }
    }
    
    private func fillTableView(_ response:Data){
        do{
            let decoder = JSONDecoder()
            let plantData = try decoder.decode(SearchPlantResponse.self, from: response)
            let plants = plantData
            self.response = plantData
            self.allPlant.append(contentsOf: plants.data)
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
            self.tableView.reloadData()
        }catch let error{
            print(error)
        }
    }
}

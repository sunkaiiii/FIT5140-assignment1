//
//  AllExhibitionViewControllerTableViewController.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 8/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit

class AllExhibitionTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ExhibitionDatabaseListener,UISearchResultsUpdating {
    var listnerType: ListenerType = .exhibition
    
    private let EXHIBITION_LIST_CELL = "exhibitionListCell"
    private let INDEX_ACENDING = 0
    private let INDEX_DECENDING = 1
    private let SELECT_INDEX = "all_exhibition_controller_selected_index"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    weak var exhibiitonDatabaseController:ExhibitionDatabaseProtocol?
    weak var exhibitionSelectedProtocol:ExhibitionSelectedProtocol?
    var allExhibition:[Exhibition] = []
    var filteredExhibition:[Exhibition] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        exhibiitonDatabaseController = appDelegate.databaseController
        filteredExhibition = allExhibition
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Exhibitions"
        
        //Init the sort
        let index = UserDefaults.standard.integer(forKey: SELECT_INDEX)
        if index == INDEX_DECENDING || index == INDEX_ACENDING{
            segmentControl.selectedSegmentIndex = index
        }else{
            segmentControl.selectedSegmentIndex = 1
        }
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        exhibiitonDatabaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        exhibiitonDatabaseController?.removeListener(listener: self)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else{
            return
        }
        
        if searchText.count > 0{
            filteredExhibition = allExhibition.filter({(exhibition)->Bool in
                guard let name = exhibition.name else{
                    return false
                }
                return name.contains(searchText)
            })
        }else{
            filteredExhibition = allExhibition
        }
        tableView.reloadData()
    }
    
    func onExhibitionListChange(change: DatabaseChange, exhibitions: [Exhibition]) {
        allExhibition = exhibitions
        guard let searchController = navigationItem.searchController else {
            return
        }
        updateSearchResults(for: searchController)
    }
    func onPlantListChange(change: DatabaseChange, plants: [Plant]) {
    }
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredExhibition.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EXHIBITION_LIST_CELL, for: indexPath) as! ExhibitionListTableViewCell
        cell.initExhibitionInformation(exhibition: filteredExhibition[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let exhibition = filteredExhibition[indexPath.row]
        if let selectedProtocol = exhibitionSelectedProtocol{
            selectedProtocol.didSelectExhibition(exhibition: exhibition)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func onValueChanged(_ sender: Any) {
        let index = segmentControl.selectedSegmentIndex
        UserDefaults.standard.set(index, forKey: SELECT_INDEX)
        sortList(index: index)
    }
    
    private func sortList(index:Int){
        if index == INDEX_ACENDING{
            filteredExhibition.sort(by:{(e1,e2) in
                return e1.name?.lowercased() ?? "" < e2.name?.lowercased() ?? ""
            })
        }else if index == INDEX_DECENDING{
            filteredExhibition.sort(by:{(e1,e2) in
                return e1.name?.lowercased() ?? "" > e2.name?.lowercased() ?? ""
            })
        }

        tableView.reloadSections([0], with: .automatic)
    }
    
}

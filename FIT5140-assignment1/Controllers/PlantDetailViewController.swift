//
//  PlantDetailViewController.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 12/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit

class PlantDetailViewController: UIViewController, EditPlantProtocol {
    let EDIT_PLANT_SEGUE = "editPlant"

    @IBOutlet weak var plantName: UILabel!
    @IBOutlet weak var plantScientificName: UILabel!
    @IBOutlet weak var plantYearDiscovered: UILabel!
    @IBOutlet weak var plantFamily: UILabel!
    @IBOutlet weak var plantImage: UIImageView!
    
    var plant:Plant?
    weak var exhibitionController:ExhibitionDatabaseProtocol?
    weak var plantChangeListener:PlantListChangeListener?
    var isPlantEdited = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.exhibitionController = appDelegate.databaseController

        if let plant = plant {
            fillDataIntoView(plant: plant)
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func fillDataIntoView(plant:UIPlant){
        self.navigationController?.title = plant.name
        self.plantName.text = plant.name
        self.plantScientificName.text = plant.scientificName
        self.plantYearDiscovered.text = "\(plant.yearDiscovered)"
        self.plantFamily.text = plant.family
        if let url = plant.imageUrl{
            ImageLoader.shared.loadImage(url, onComplete:{(url, image) in
                if let image = image {
                    self.plantImage.image = image
                }
            })
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        URLSession.shared.invalidateAndCancel()
        
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == EDIT_PLANT_SEGUE{
            guard let controller = segue.destination as? EditPlantViewController,let plant = plant else{
                return
            }
            controller.plant = plant
            controller.editPlantProtocol = self
        }
    }
    
    func editPlant(newPlant: UIPlant) -> Bool {
        guard let oldPlant = self.plant else{
            return false
        }
        self.plant = self.exhibitionController?.updatePlant(oldPlant: oldPlant, newPlant: newPlant)
        if let plant = self.plant{
            isPlantEdited = true
            fillDataIntoView(plant: plant)
            plantChangeListener?.onPlantListChanged()
            return true
        }
        return false
    }

}

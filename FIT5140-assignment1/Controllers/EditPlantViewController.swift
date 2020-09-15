//
//  EditPlantViewController.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 13/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit

class EditPlantViewController: UIViewController {

    @IBOutlet weak var plantName: UITextField!
    @IBOutlet weak var plantScientificName: UITextField!
    @IBOutlet weak var plantFamily: UITextField!
    @IBOutlet weak var plantYearDiscovered: UITextField!
    @IBOutlet weak var plantImage: UIImageView!
    
    var plant:UIPlant?
    weak var editPlantProtocol:EditPlantProtocol?
    
    var imageUrl:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let plant = self.plant {
            plantName.text = plant.name
            plantScientificName.text = plant.scientificName
            plantFamily.text = plant.family
            plantYearDiscovered.text = "\(plant.yearDiscovered)"
            imageUrl = plant.imageUrl
            if let imageUrl = plant.imageUrl{
                ImageLoader.shraed.loadImage(imageUrl, onComplete: {(url,image) in
                    self.plantImage.image = image
                })
            }
        }
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        let newPlant = UIPlantImpl(name: plantName.text, yearDiscovered: Int32(plantYearDiscovered?.text ?? "0") ?? 0, imageUrl: imageUrl, scientificName: plant?.scientificName, family: plant?.family, isFromDatabase: true)
        let result = editPlantProtocol?.editPlant(newPlant: newPlant)
        if result ?? false{
            navigationController?.popViewController(animated: true)
        }
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

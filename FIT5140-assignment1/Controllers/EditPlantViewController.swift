//
//  EditPlantViewController.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 13/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit

class EditPlantViewController: UIViewController,ImagePickerDelegate {

    @IBOutlet weak var plantName: UITextField!
    @IBOutlet weak var plantScientificName: UITextField!
    @IBOutlet weak var plantFamily: UITextField!
    @IBOutlet weak var plantYearDiscovered: UITextField!
    @IBOutlet weak var plantImage: UIImageView!
    
    var imagePicker:ImagePicker?
    var plant:UIPlant?
    weak var editPlantProtocol:EditPlantProtocol?
    
    var imageUrl:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = ImagePicker(presentationController: self, delegate: self)
        plantName.delegate = self
        plantScientificName.delegate = self
        plantFamily.delegate = self
        plantYearDiscovered.delegate = self
        
        if let plant = self.plant {
            plantName.text = plant.name
            plantScientificName.text = plant.scientificName
            plantFamily.text = plant.family
            plantYearDiscovered.text = "\(plant.yearDiscovered)"
            imageUrl = plant.imageUrl
            ImageLoader.simpleLoad(imageUrl, imageView: plantImage)
        }
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        if checkValid() == false{
            return
        }
        let newPlant = UIPlantImpl(name: plantName.text, yearDiscovered: Int32(plantYearDiscovered?.text ?? "0") ?? 0, imageUrl: imageUrl, scientificName: plant?.scientificName, family: plant?.family, isFromDatabase: true)
        let result = editPlantProtocol?.editPlant(newPlant: newPlant)
        if result ?? false{
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func changeImage(_ sender: Any) {
        imagePicker?.present(from: sender as! UIView)
    }
    
    private func checkValid()->Bool{
        if plantName.text?.count == 0{
            showAltert(title: "The plant name cannot be empty", message: nil)
            return false
        }
        if plantScientificName.text?.count == 0{
            showAltert(title: "The plant scientific name cannot be empty", message: nil)
            return false
        }
        
        if plantFamily.text?.count == 0{
            showAltert(title: "The plant family cannot be empty", message: nil)
            return false
        }
        let yearDiscover = Int32(plantYearDiscovered.text ?? "-1") ?? -1
        if yearDiscover < 0{
            showAltert(title: "The plant discovered year cannot be negative", message: nil)
            return false
        }else if yearDiscover > Calendar.current.component(.year, from: Date()){
            showAltert(title: "The plant discovered year cannot be over this year", message: nil)
            return false
        }
        return true
    }
    
    func didSelect(imageUrl: String, image: UIImage?) {
        guard let image = image else {
            return
        }
        self.imageUrl = imageUrl
        self.plantImage.image = image
    }


}

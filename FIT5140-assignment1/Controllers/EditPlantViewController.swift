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
        if let plant = self.plant {
            plantName.text = plant.name
            plantScientificName.text = plant.scientificName
            plantFamily.text = plant.family
            plantYearDiscovered.text = "\(plant.yearDiscovered)"
            imageUrl = plant.imageUrl
            if let imageUrl = plant.imageUrl{
                ImageLoader.shared.loadImage(imageUrl, onComplete: {(url,image) in
                    self.plantImage.image = image
                })
            }
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
        guard let name = plantName.text,let scientificName = plantScientificName.text, let family = plantFamily.text, let yearDiscovered = Int32(plantYearDiscovered.text ?? "-1"), let imageUrl = imageUrl, name.count>0, scientificName.count>0, family.count>0, imageUrl.count>0, yearDiscovered > 1230 else {
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

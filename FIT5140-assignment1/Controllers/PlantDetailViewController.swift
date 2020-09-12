//
//  PlantDetailViewController.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 12/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit

class PlantDetailViewController: UIViewController {

    @IBOutlet weak var plantName: UILabel!
    @IBOutlet weak var plantScientificName: UILabel!
    @IBOutlet weak var plantYearDiscovered: UILabel!
    @IBOutlet weak var plantFamily: UILabel!
    @IBOutlet weak var plantImage: UIImageView!
    
    var plant:Plant?
    override func viewDidLoad() {
        super.viewDidLoad()

        if let plant = plant {
            self.navigationController?.title = plant.name
            self.plantName.text = plant.name
            self.plantScientificName.text = plant.scientificName
            self.plantYearDiscovered.text = "\(plant.yearDiscovered)"
            self.plantFamily.text = plant.family
            if let url = plant.imageUrl{
                ImageLoader.shraed.loadImage(url, onComplete:{(url, image) in
                    if let image = image {
                        self.plantImage.image = image
                    }
                })
            }
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        URLSession.shared.invalidateAndCancel()
        
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

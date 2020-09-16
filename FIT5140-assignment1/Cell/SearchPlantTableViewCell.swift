//
//  SearchPlantTableViewCell.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 16/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit

class SearchPlantTableViewCell: UITableViewCell {

    @IBOutlet weak var plantName: UILabel!
    @IBOutlet weak var plantScientificName: UILabel!
    @IBOutlet weak var plantImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func fillDataIntoView(plant:UIPlant){
        plantName.text = plant.name
        plantScientificName.text = plant.name
        plantImage.image = nil
        if let imageUrl = plant.imageUrl{
            ImageLoader.shared.loadImage(imageUrl, onComplete: {(imageUrl,image) in
                if let image = image{
                    self.plantImage.image = image
                }
            })
        }

    }
}

//
//  ExhibitionPlantTableViewCell.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 12/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit

class ExhibitionPlantTableViewCell: UITableViewCell {

    @IBOutlet weak var plantName: UILabel!
    @IBOutlet weak var plantScienceNameAndYear: UILabel!
    @IBOutlet weak var plantImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showPlantDetail(_ plant:Plant){
        self.plantName.text = plant.name
        self.plantScienceNameAndYear.text = "\(plant.scientificName ?? "") (\(plant.yearDiscovered))"
        if let imageUrl = plant.imageUrl{
            ImageLoader.shraed.loadImage(imageUrl, onComplete: {(imageUrl,image) in
                if let image = image{
                    self.plantImage.image = image.circleMasked
                }
            })
        }
    }

}

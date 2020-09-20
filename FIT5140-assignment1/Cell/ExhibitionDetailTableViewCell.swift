//
//  ExhibitionDetailTableViewCell.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 12/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit
import MapKit

class ExhibitionDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var exhibitionName: UILabel!
    @IBOutlet weak var exhibitionLocation: UILabel!
    @IBOutlet weak var exhibitionDescription: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func showExhibitionDetail(_ exhibition:UIExhibition){
        let location = CLLocation(latitude: exhibition.latitude, longitude: exhibition.longitude)
        //convert latitude and longitude into a user friendly representation
        convertCoordinateToCurrentLocation(location: location, completionHandler: {(placeMark) in
            guard let placeMark = placeMark else{
                return
            }
            self.exhibitionLocation.text = placeMark.getFullAdress()
        })
        self.exhibitionDescription.text = exhibition.desc
        self.exhibitionName.text = exhibition.name
    }
}

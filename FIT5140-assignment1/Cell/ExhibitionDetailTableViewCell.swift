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

    func showExhibitionDetail(_ annotation:ExhibitsLocationAnnotation){
        let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        convertCoordinateToCurrentLocation(location: location, completionHandler: {(placeMark) in
            guard let placeMark = placeMark else{
                return
            }
            self.exhibitionLocation.text = "\(placeMark.name ?? "") \(placeMark.thoroughfare ?? "") \(placeMark.locality ?? "") \(placeMark.postalCode ?? "") \(placeMark.country ?? "")"
        })
        self.exhibitionDescription.text = annotation.desc
        self.exhibitionName.text = annotation.title
    }
}

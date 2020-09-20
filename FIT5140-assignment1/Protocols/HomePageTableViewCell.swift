//
//  HomePageTableViewCell.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 20/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit
import MapKit

class HomePageTableViewCell: UITableViewCell {

    @IBOutlet weak var exhibitionName: UILabel!
    @IBOutlet weak var exhibitionLocation: UILabel!
    @IBOutlet weak var exhibitionDesc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initExhibitionCell(exhibition:UIExhibition){
        exhibitionName.text = exhibition.name
        convertCoordinateToCurrentLocation(location: CLLocation(latitude: exhibition.latitude, longitude: exhibition.longitude), completionHandler: {(placeMark) in
            self.exhibitionLocation.text = placeMark?.getCompatAddress()
        })
        exhibitionDesc.text = exhibition.desc
    }

}

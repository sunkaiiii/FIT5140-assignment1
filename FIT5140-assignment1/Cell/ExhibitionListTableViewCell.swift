//
//  ExhibitionListTableViewCell.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 8/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit

class ExhibitionListTableViewCell: UITableViewCell {
    @IBOutlet weak var exhibitionImage: UIImageView!
    @IBOutlet weak var exhibitionTitle: UILabel!
    @IBOutlet weak var exhibitionSubtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initExhibitionInformation(exhibition:Exhibition){
        exhibitionImage.image = UIImage(named: exhibition.name!)?.circleMasked
        exhibitionTitle.text = exhibition.name
        exhibitionSubtitle.text = exhibition.subtitle
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

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
        exhibitionImage.image = nil
        exhibitionTitle.text = exhibition.name
        exhibitionSubtitle.text = exhibition.subtitle
        if let imageUrl = exhibition.imageUrl, let image = UIImage(named: imageUrl){
            self.exhibitionImage.image = image
        }else if let imageUrl = exhibition.imageUrl{
            ImageLoader.shared.loadImage(imageUrl, onComplete: {(imageUrl,image) in
                self.exhibitionImage.image = image
            })
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

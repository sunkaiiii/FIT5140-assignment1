//
//  ExhibitionListTableViewCell.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 8/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit

//The cell of the exhibition list
class ExhibitionListTableViewCell: UITableViewCell {
    @IBOutlet weak var exhibitionImage: UIImageView!
    @IBOutlet weak var exhibitionTitle: UILabel!
    @IBOutlet weak var exhibitionSubtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initExhibitionInformation(exhibition:UIExhibition){
        exhibitionImage.image = nil
        exhibitionTitle.text = exhibition.name
        exhibitionSubtitle.text = exhibition.subtitle
        let indicator = UIActivityIndicatorView()
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = exhibitionImage.center
        if let imageUrl = exhibition.imageUrl{
            ImageLoader.load(imageUrl).placeHolder(indicator).into(exhibitionImage)
        }
//        if let imageUrl = exhibition.imageUrl, let image = UIImage(named: imageUrl){
//            self.exhibitionImage.image = image
//        }else if let imageUrl = exhibition.imageUrl{
//            ImageLoader.shared.loadImage(imageUrl, onComplete: {(imageUrl,image) in
//                self.exhibitionImage.image = image
//            })
//        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

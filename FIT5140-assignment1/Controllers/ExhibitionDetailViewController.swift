//
//  ExhibitionDetailViewController.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 8/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit
import MapKit

class ExhibitionDetailViewController: UIViewController {

    var annotation:MKAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = annotation!.title!!
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

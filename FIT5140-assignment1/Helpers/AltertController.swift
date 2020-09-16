//
//  AltertController.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 16/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func showAltert(title:String, message:String?){
        let altertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        altertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(altertController, animated: true, completion: nil)
    }
}

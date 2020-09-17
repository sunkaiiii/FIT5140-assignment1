//
//  UITextFieldHelper.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 17/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController:UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

//
//  ViewController.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 27/8/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit

class ViewController: UIViewController,HTTPRequestAction {


    override func viewDidLoad() {
        super.viewDidLoad()
        requestRestfulService(api: PlantRequestAPI.getPlant, model: Plant())
    }
    
    func beforeExecution(helper: RequestHelper) {
            
    }
    
    func executionFailed(helper: RequestHelper, message: String, error: Error) {
        
    }
    
    func afterExecution(helper: RequestHelper, response: String) {
        
    }
    

}


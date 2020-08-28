//
//  RequestHelper.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 28/8/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit

class RequestHelper: NSObject {
    let restfulAPI:RestfulAPI
    let requestModel:RequestModel
    
    init(api:RestfulAPI, model:RequestModel){
        self.restfulAPI = api
        self.requestModel = model
    }
}

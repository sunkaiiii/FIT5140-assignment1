//
//  NetworkExtension.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 28/8/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import Foundation

extension HTTPRequestAction{
    func requestRestfulService(api:RestfulAPI, model:RequestModel){
        NetworkRequestTask(helper: RequestHelper(api: api, model: model), action: self).fetchDataFromSever()
    }

}


extension NSObject{
    func getJsonDecoder()->JSONDecoder{
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }
}

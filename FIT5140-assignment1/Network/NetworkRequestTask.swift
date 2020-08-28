//
//  NetworkRequestTask.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 28/8/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit

class NetworkRequestTask: NSObject {
    let requestHelper:RequestHelper
    let requestAction:HTTPRequestAction
    
    init(helper:RequestHelper, action:HTTPRequestAction){
        self.requestHelper = helper
        self.requestAction = action
    }
    
    func fetchDataFromSever(){
        let url = buildRequestUrl()
        requestAction.beforeExecution(helper: requestHelper)
        
        URLSession.shared.dataTask(with:url){(data:Data?, response:URLResponse?,error:Error?) in
            if let error = error{
                self.requestAction.executionFailed(helper: self.requestHelper, message: error.localizedDescription, error: error)
            }
            if let data = data {
                print(data.base64EncodedString())
            }
        }.resume()
    }
    
    private func buildRequestUrl()->URL{
        let model = requestHelper.requestModel
        let api = requestHelper.restfulAPI
        let pathParameter = model.getPathParameter()
        let host = api.getRequestHost()
        var url = ""
        url += host.getScheme()+"://"
        url += host.getHostUrl()
        url += ":\(host.getPort())"
        url += api.getRoute()
        for path in pathParameter{
            url += "/"+path
        }
        let queryParameter = model.getQueryParameter()
        if queryParameter.count>0{
            var i = 0
            for query in queryParameter {
                if i==0 {
                    url += "?"
                }else{
                    url += "&"
                }
                url += query.key + "=" + query.value
                i = i+1
            }
        }
        print(url)
        return URL(string: url)!
    }
}

extension URLSession{
    func dataTask(with url:URL,result:@escaping (Result<(URLResponse, Data),Error>)->Void)->URLSessionDataTask{
        return dataTask(with: url){(data,response,error)in
            if let error = error{
                print("error")
                result(.failure(error))
                return
            }
            
            guard let response = response, let data = data else{
                print("error")
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            print("success")
            result(.success((response,data)))
        }
    }
}

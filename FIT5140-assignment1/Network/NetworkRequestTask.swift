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
        guard let url = buildRequestUrl() else{
            return
        }
        requestAction.beforeExecution(helper: requestHelper)
        
        URLSession.shared.dataTask(with: url, result: {(result) in
            switch result{
                case .success(let (response,data)):
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
//                        self.requestAction.executionFailed(helper: requestHelper, message: "InvalidResponse", error: )
                        return
                }
                    self.requestAction.afterExecution(helper: self.requestHelper, response: data)
                case .failure(let error):
                    self.requestAction.executionFailed(helper: self.requestHelper, message: "Error happened", error: error)
                default:
                    return
                }
            }).resume()
//        URLSession.shared.dataTask(with:url){(data:Data?, response:URLResponse?,error:Error?) in
//            if let error = error{
//                self.requestAction.executionFailed(helper: self.requestHelper, message: error.localizedDescription, error: error)
//            }
//            if let data = data {
//                print(data.base64EncodedString())
//            }
//        }.resume()
    }
    
    private func buildRequestUrl()->URL?{
        let model = requestHelper.requestModel
        let api = requestHelper.restfulAPI
        let host = api.getRequestHost()
        var urlComponents = URLComponents()
        urlComponents.scheme = host.getScheme()
        urlComponents.host = host.getHostUrl()
        urlComponents.port = host.getPort()
        urlComponents.path = api.getRoute()
        let pathParameter = model.getPathParameter()
        for path in pathParameter{
            urlComponents.path += "/"+path
        }
        var queryItems:[URLQueryItem] = []
        for query in model.getQueryParameter(){
            queryItems.append(URLQueryItem(name: query.key, value: query.value))
        }
        urlComponents.queryItems = queryItems
        print(urlComponents.url?.absoluteString ?? "")
        return urlComponents.url!
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

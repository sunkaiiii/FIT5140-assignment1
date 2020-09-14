//
//  RestfulAPI.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 27/8/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import Foundation

let HTTP = 80
let HTTPS = 443
enum RequestType{
    case GET
    case POST
    case PUT
    case DELETE
}

enum RequestHost:Host{
    case trefle
    func getHostUrl() -> String {
        switch self {
        case .trefle:
            return "trefle.io"
        default:
            return ""
        }
    }
    
    func getPort() -> Int {
        switch self {
        case .trefle:
            return HTTPS
        default:
            return HTTPS
        }
    }
    
    func getScheme() -> String {
        switch self {
        case .trefle:
            return "https"
        default:
            return "https"
        }
    }
    
    
}

enum PlantRequestAPI:RestfulAPI{
    case searchPlant
    func getRequestName() -> String {
        switch self {
        case .searchPlant:
            return "searchPlant"
        default:
            return ""
        }
    }
    
    func getRoute() -> String {
        switch self {
        case .searchPlant:
            return "/api/v1/plants/search"
        default:
            return ""
        }
    }
    
    func getRequestType() -> RequestType {
        switch self {
        case .searchPlant:
            return RequestType.GET
        default:
            return RequestType.GET
        }
    }
    
    func getRequestHost() -> RequestHost {
        switch self {
        case .searchPlant:
            return RequestHost.trefle
        default:
            return RequestHost.trefle
        }
    }
}

protocol RestfulAPI {
    func getRequestName()->String
    func getRoute()->String
    func getRequestType()->RequestType
    func getRequestHost()->RequestHost
}


protocol Host {
    func getHostUrl()->String
    func getPort()->Int
    func getScheme()->String
}



protocol RequestModel {
    func getPathParameter()->[String]
    func getHeader()->[String:String]
    func getQueryParameter()->[String:String]
    func getBody()->[String]
}


protocol HTTPRequestAction {
    func beforeExecution(helper:RequestHelper)
    func executionFailed(helper:RequestHelper, message:String, error:Error)
    func afterExecution(helper:RequestHelper, response:Data)
}

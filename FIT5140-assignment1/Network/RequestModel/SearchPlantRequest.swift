//
//  Plant.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 28/8/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import Foundation

struct SearchPlantRequest:RequestModel {
    let searchText:String
    var page:Int
    init(searchText:String, page:Int) {
        self.searchText = searchText
        self.page = page
    }
    func getPathParameter() -> [String] {
        return []
    }
    
    func getHeader() -> [String : String] {
        return [:]
    }
    
    func getQueryParameter() -> [String : String] {
        return ["token":"i9h6hy6ZYVZmTWuowG8g5a3ZWK3ffQ9LoRI6RhLiZCU","q":searchText,"page":"\(page)"]
    }
    
    func getBody() -> [String] {
        return []
    }
    
    
}

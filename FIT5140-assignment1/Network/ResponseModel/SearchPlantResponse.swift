//
//  SearchPlantResponse.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 14/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import Foundation

class SearchPlantResponse: Codable {
    let data: [PlantResponse]
    let links: Links
    init(data: [PlantResponse], links:Links) {
        self.data = data
        self.links = links
    }
}

class PlantResponse: Codable,UIPlant {
    
    var isFromDatabase: Bool?
    var name, slug, scientificName: String?
    var year: Int32?
    var yearDiscovered: Int32 {get{year ?? 0}}
    var bibliography, author, rank, familyCommonName: String?
    var imageUrl: String?
    var synonyms: [String]?
    var genus, family: String?

    enum CodingKeys: String, CodingKey {
        case name = "common_name"
        case slug
        case scientificName = "scientific_name"
        case year
        case bibliography, author, rank
        case familyCommonName = "family_common_name"
        case imageUrl = "image_url"
        case synonyms, genus, family
        case isFromDatabase
    }

    init(commonName: String, slug: String, scientificName: String, yearDiscovered: Int, bibliography: String, author: String, rank: String, familyCommonName: String, imageURL: String, synonyms: [String], genus: String, family: String) {
        self.name = commonName
        self.slug = slug
        self.scientificName = scientificName
        self.year = Int32(yearDiscovered)
        self.bibliography = bibliography
        self.author = author
        self.rank = rank
        self.familyCommonName = familyCommonName
        self.imageUrl = imageURL
        self.synonyms = synonyms
        self.genus = genus
        self.family = family
    }
    
    init(plant:Plant) {
        self.name = plant.name
        self.scientificName = plant.scientificName
        self.year = plant.yearDiscovered
        self.family = plant.family
        self.imageUrl = plant.imageUrl
    }
}

class Links: Codable {
    let linksSelf, first, next, last: String?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case first, next, last
    }

    init(linksSelf: String, first: String, next: String, last: String) {
        self.linksSelf = linksSelf
        self.first = first
        self.next = next
        self.last = last
    }
}


extension Plant{
    func toPlantResponseModel()->PlantResponse{
        return PlantResponse(plant: self)
    }
}

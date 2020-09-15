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

    init(data: [PlantResponse]) {
        self.data = data
    }
}

class PlantResponse: Codable,UIPlant {
    var isFromDatabase: Bool?
    var name, slug, scientificName: String?
    var yearDiscovered: Int32
    var bibliography, author, rank, familyCommonName: String?
    var imageUrl: String?
    var synonyms: [String]?
    var genus, family: String?

    enum CodingKeys: String, CodingKey {
        case name = "common_name"
        case slug
        case scientificName = "scientific_name"
        case yearDiscovered = "year"
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
        self.yearDiscovered = Int32(yearDiscovered)
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
        self.yearDiscovered = plant.yearDiscovered
        self.family = plant.family
        self.imageUrl = plant.imageUrl
    }
}

extension Plant{
    func toPlantResponseModel()->PlantResponse{
        return PlantResponse(plant: self)
    }
}

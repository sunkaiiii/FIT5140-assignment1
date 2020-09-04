//
//  ExhibitLocationHelper.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 4/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import Foundation

func createDefaultExhibits()->[ExhibitsLocationAnnotation]{
    var defaultList:[ExhibitsLocationAnnotation] = []
    defaultList.append(ExhibitsLocationAnnotation(title: "The Tropical Glasshouse", desc: "The Tropical Glasshouse at Melbourne Gardens showcases plants from tropical regions around the globe, and displays some of the most important and spectacular tropical rainforest plants known to man.", latitude: -37.832062, longitude: 144.979478))
    defaultList.append(ExhibitsLocationAnnotation(title: "Species Rose Collection", desc: "With more than 100 different species and varieties of roses the collection at Melbourne Gardens always has something to offer. Come in spring to see species roses from the northern hemisphere and cultivars bred both here in Australia and overseas in flower. In autumn delight in the changing colour of the foliage and rose hips. In winter admire the varied forms of the rose.", latitude: -37.830625, longitude: 144.983394))
    defaultList.append(ExhibitsLocationAnnotation(title: "Oak Collection", desc: "The great trees of Melbourne Gardens are spectacular throughout the year, but autumn is a particularly special time when the elms, oaks, and many other deciduous trees explode into a mass of vibrant yellow, red and orange.", latitude: -37.831074, longitude: 144.977985))
    defaultList.append(ExhibitsLocationAnnotation(title: "Herb Garden", desc: "A wide range of herbs from well known leafy annuals such as Basil and Coriander, to majestic mature trees such as the Camphor Laurels Cinnamomum camphora and Cassia Bark Tree Cinnamomum burmannii. The large trees are remnants from the original 1890s Medicinal Garden. Plants displayed are from all over the world including Australia, and several are rare or have been collected from the wild.", latitude: -37.831486, longitude: 144.979375))
    defaultList.append(ExhibitsLocationAnnotation(title: "Bamboo Collection", desc: "Melbourne Gardens exhibits a broad range of Bamboo from different regions of the world across the entire site and maintains a consolidated collection within the Bamboo Collection beds. A key objective of the Bamboo collection is to highlight the significant ethnobotanical uses of bamboo and grasses and the vital role they contribute to for life on earth and highlights the threats to grass biodiversity and biomes they support. ", latitude: -37.830464, longitude: 144.980314))
    defaultList.append(ExhibitsLocationAnnotation(title: "Water Conservation Garden", desc: "The Water Conservation Garden is designed to demonstrate water saving techniques. Signs at the garden explain ways to save water, such as plant selection and mulching. The design and planting of the garden give ideas and inspiration to the home gardener. The plants grown come from countries with a climate similar to Melbourne’s and show a range of form and colour. Most of the plants are available in general nurseries, some are found only in specialist nurseries.", latitude: -37.830667, longitude: 144.982474))
    return defaultList
}

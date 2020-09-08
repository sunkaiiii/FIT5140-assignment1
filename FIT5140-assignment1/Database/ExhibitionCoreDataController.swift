//
//  ExhibitionCoreDataController.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 8/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import Foundation
import CoreData

class ExhibitionCoreDataController:NSObject,ExhibitionDatabaseProtocol, NSFetchedResultsControllerDelegate{

    
    var persistentContainer:NSPersistentContainer
    var allExhibitionFetchedResultController:NSFetchedResultsController<Exhibition>?
    var listeners = MulticastDelegate<ExhibitionDatabaseListener>()
    
    override init() {
        persistentContainer = NSPersistentContainer(name: "ExhibitionDataModel")
        persistentContainer.loadPersistentStores(){(description, error) in
            if let error = error{
                fatalError("Failed to laod Core data stack:\(error)")
            }
        }
        super.init()
        
        if fecthAllExhibition().count == 0{
            createDefaultExhibits()
        }
    }
    
    func fecthAllExhibition()->[Exhibition]{
        if allExhibitionFetchedResultController == nil{
            let fetchRequest:NSFetchRequest<Exhibition> = Exhibition.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            allExhibitionFetchedResultController = NSFetchedResultsController<Exhibition>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            allExhibitionFetchedResultController?.delegate = self
            do{
                try allExhibitionFetchedResultController?.performFetch()
            }catch{
                print("Fetch Request Failed:\(error)")
            }
        }
        var exhibitions = [Exhibition]()
        if let result = allExhibitionFetchedResultController?.fetchedObjects {
            exhibitions = result
        }
        return exhibitions
    }
    
    func addExhibition(name: String,subtitle:String, desc: String, latitude: Double, longitude: Double)->Exhibition {
        let exhibition = NSEntityDescription.insertNewObject(forEntityName: "Exhibition", into: persistentContainer.viewContext) as! Exhibition
        exhibition.name = name
        exhibition.desc = desc
        exhibition.latitude = latitude
        exhibition.longitude = longitude
        exhibition.subtitle = subtitle
        return exhibition
    }
    
    func addListener(listener:ExhibitionDatabaseListener){
        listeners.addDelegate(listener)
        listener.onExhibitionListChange(change: .update, exhibitions: fecthAllExhibition())
    }
    func removeListener(listener:ExhibitionDatabaseListener){
        listeners.removeDelegate(listener)
    }
    
    func saveContext(){
        if persistentContainer.viewContext.hasChanges{
            do{
                try persistentContainer.viewContext.save()
            }catch{
                fatalError("Failed to save to CoreData:\(error)")
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == allExhibitionFetchedResultController{
            listeners.invoke{(listener) in
                listener.onExhibitionListChange(change: .update, exhibitions: fecthAllExhibition())
            }
        }
    }
    
    func cleanup(){
        saveContext()
    }
    
    func createDefaultExhibits(){
        let _ = addExhibition(name: "The Tropical Glasshouse",subtitle: "The Tropical Glasshouse showcases plants from tropical regions around the globe, and displays some of the most important and spectacular...", desc: "The Tropical Glasshouse at Melbourne Gardens showcases plants from tropical regions around the globe, and displays some of the most important and spectacular tropical rainforest plants known to man.", latitude: -37.832062, longitude: 144.979478)
        let _ = addExhibition(name: "Species Rose Collection",subtitle: "Lovers of the world's most popular flower, the rose, are delighted by Melbourne Gardens collection of 'species' and old fashioned roses. A..." ,desc: "With more than 100 different species and varieties of roses the collection at Melbourne Gardens always has something to offer. Come in spring to see species roses from the northern hemisphere and cultivars bred both here in Australia and overseas in flower. In autumn delight in the changing colour of the foliage and rose hips. In winter admire the varied forms of the rose.", latitude: -37.830625, longitude: 144.983394)
        let _ = addExhibition(name: "Oak Collection",subtitle: "Melbourne Gardens features a variety of oaks from around the world. With over 40 species on display and specimens over 130 years old, this...", desc: "The great trees of Melbourne Gardens are spectacular throughout the year, but autumn is a particularly special time when the elms, oaks, and many other deciduous trees explode into a mass of vibrant yellow, red and orange.", latitude: -37.831074, longitude: 144.977985)
        let _ = addExhibition(name: "Herb Garden",subtitle: "A unique collection of plants useful to people: for flavoring food, as medicines, for fragrance, dyeing fabric, fibre plants, spiritual...", desc: "A wide range of herbs from well known leafy annuals such as Basil and Coriander, to majestic mature trees such as the Camphor Laurels Cinnamomum camphora and Cassia Bark Tree Cinnamomum burmannii. The large trees are remnants from the original 1890s Medicinal Garden. Plants displayed are from all over the world including Australia, and several are rare or have been collected from the wild.", latitude: -37.831486, longitude: 144.979375)
        let _ = addExhibition(name: "Bamboo Collection",subtitle: "This is a Taxonomic and Evolutionary collection.", desc: "Melbourne Gardens exhibits a broad range of Bamboo from different regions of the world across the entire site and maintains a consolidated collection within the Bamboo Collection beds. A key objective of the Bamboo collection is to highlight the significant ethnobotanical uses of bamboo and grasses and the vital role they contribute to for life on earth and highlights the threats to grass biodiversity and biomes they support. ", latitude: -37.830464, longitude: 144.980314)
        let _ = addExhibition(name: "Water Conservation Garden",subtitle: "An attractive display of Australian and exotic plants with low water requirements for use in the home garden." ,desc: "The Water Conservation Garden is designed to demonstrate water saving techniques. Signs at the garden explain ways to save water, such as plant selection and mulching. The design and planting of the garden give ideas and inspiration to the home gardener. The plants grown come from countries with a climate similar to Melbourne’s and show a range of form and colour. Most of the plants are available in general nurseries, some are found only in specialist nurseries.", latitude: -37.830667, longitude: 144.982474)
    }

}

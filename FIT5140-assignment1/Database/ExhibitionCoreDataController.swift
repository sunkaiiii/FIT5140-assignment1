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
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Exhibition")
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        do {
//            try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: persistentContainer.viewContext)
//        } catch let error as NSError {
//            // TODO: handle the error
//        }
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
    
    func deleteExhibition(exhibition: Exhibition) {
        persistentContainer.viewContext.delete(exhibition)
    }
    
    func deletePlant(plant: Plant) {
        persistentContainer.viewContext.delete(plant)
    }
    
    func deletePlantFromExhibition(plant: Plant, exhibiton: Exhibition) {
        exhibiton.removeFromPlants(plant)
    }
    
    func addPlant(name: String, yearDiscovered: Int, family: String, scientificName: String,imageUrl:String?) -> Plant {
        let plant = NSEntityDescription.insertNewObject(forEntityName: "Plant", into: persistentContainer.viewContext) as! Plant
        plant.name = name
        plant.yearDiscovered = Int32(yearDiscovered)
        plant.family = family
        plant.scientificName = scientificName
        plant.imageUrl = imageUrl
        return plant
    }
    
    func addPlantToExhibition(plant: Plant, exhibition: Exhibition)->Bool {
        guard let plants = exhibition.plants, plants.contains(plant) == false else{
            return false
        }
        exhibition.addToPlants(plant)
        return true
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
        let tropical = addExhibition(name: "The Tropical Glasshouse",subtitle: "The Tropical Glasshouse showcases plants from tropical regions around the globe, and displays some of the most important and spectacular...", desc: "The Tropical Glasshouse at Melbourne Gardens showcases plants from tropical regions around the globe, and displays some of the most important and spectacular tropical rainforest plants known to man.", latitude: -37.832062, longitude: 144.979478)
        let speciesRose = addExhibition(name: "Species Rose Collection",subtitle: "Lovers of the world's most popular flower, the rose, are delighted by Melbourne Gardens collection of 'species' and old fashioned roses. A..." ,desc: "With more than 100 different species and varieties of roses the collection at Melbourne Gardens always has something to offer. Come in spring to see species roses from the northern hemisphere and cultivars bred both here in Australia and overseas in flower. In autumn delight in the changing colour of the foliage and rose hips. In winter admire the varied forms of the rose.", latitude: -37.830625, longitude: 144.983394)
        let oakCollection = addExhibition(name: "Oak Collection",subtitle: "Melbourne Gardens features a variety of oaks from around the world. With over 40 species on display and specimens over 130 years old, this...", desc: "The great trees of Melbourne Gardens are spectacular throughout the year, but autumn is a particularly special time when the elms, oaks, and many other deciduous trees explode into a mass of vibrant yellow, red and orange.", latitude: -37.831074, longitude: 144.977985)
        let herbGarden = addExhibition(name: "Herb Garden",subtitle: "A unique collection of plants useful to people: for flavoring food, as medicines, for fragrance, dyeing fabric, fibre plants, spiritual...", desc: "A wide range of herbs from well known leafy annuals such as Basil and Coriander, to majestic mature trees such as the Camphor Laurels Cinnamomum camphora and Cassia Bark Tree Cinnamomum burmannii. The large trees are remnants from the original 1890s Medicinal Garden. Plants displayed are from all over the world including Australia, and several are rare or have been collected from the wild.", latitude: -37.831486, longitude: 144.979375)
        let bambooCollection = addExhibition(name: "Bamboo Collection",subtitle: "This is a Taxonomic and Evolutionary collection.", desc: "Melbourne Gardens exhibits a broad range of Bamboo from different regions of the world across the entire site and maintains a consolidated collection within the Bamboo Collection beds. A key objective of the Bamboo collection is to highlight the significant ethnobotanical uses of bamboo and grasses and the vital role they contribute to for life on earth and highlights the threats to grass biodiversity and biomes they support. ", latitude: -37.830464, longitude: 144.980314)
        let waterConservation = addExhibition(name: "Water Conservation Garden",subtitle: "An attractive display of Australian and exotic plants with low water requirements for use in the home garden." ,desc: "The Water Conservation Garden is designed to demonstrate water saving techniques. Signs at the garden explain ways to save water, such as plant selection and mulching. The design and planting of the garden give ideas and inspiration to the home gardener. The plants grown come from countries with a climate similar to Melbourne’s and show a range of form and colour. Most of the plants are available in general nurseries, some are found only in specialist nurseries.", latitude: -37.830667, longitude: 144.982474)
        
        let titanArum = addPlant(name: "Titan arum", yearDiscovered: 1879, family: "Araceae", scientificName: "Amorphophallus titanum", imageUrl: "https://bs.floristic.org/image/o/0b91dd94ae0a9a615155fd236db95512c5bc64ea")
        let _ = addPlantToExhibition(plant: titanArum, exhibition: tropical)
        let stanhopea = addPlant(name: "Stanhopea tigrina", yearDiscovered: 1838, family: "Orchidaceae", scientificName: "Stanhopea tigrina", imageUrl: "https://bs.floristic.org/image/o/16cd867da29fe3d05b5180c10477ce0e483b2dd8")
        let _ = addPlantToExhibition(plant: stanhopea, exhibition: tropical)
        let ceratozamia = addPlant(name: "Cycad", yearDiscovered: 1846, family: "Zamiaceae", scientificName: "Ceratozamia mexicana", imageUrl: "https://bs.floristic.org/image/o/263c5f3d11bce828148a2cd0b6bacfcfdf7a355a")
        let _ = addPlantToExhibition(plant: ceratozamia, exhibition: tropical)
        
        let rosaXanthina = addPlant(name: "yellow rose", yearDiscovered: 1820, family: "Rosaceae", scientificName: "Rosa xanthina", imageUrl: "https://bs.floristic.org/image/o/6416eb252e4e3d359aa298647c1568ed8ad03b90")
        let rosaRugosa = addPlant(name: "rugosa rose", yearDiscovered: 1784, family: "Rosaceae", scientificName: "Rosa rugosa", imageUrl: "https://bs.floristic.org/image/o/fe957b1a87df808443782ad72c2c0ddec0729370")
        let rosaRoxburghii = addPlant(name: "chestnut rose", yearDiscovered: 1823, family: "Rosaceae", scientificName: "Rosa roxburghii", imageUrl: "https://bs.floristic.org/image/o/2d6c25e69331c645e31cc46d9f8f8e3b2a2090c0")
        let _ = addPlantToExhibition(plant: rosaXanthina, exhibition: speciesRose)
        let _ = addPlantToExhibition(plant: rosaRugosa, exhibition: speciesRose)
        let _ = addPlantToExhibition(plant: rosaRoxburghii, exhibition: speciesRose)
        
        let algerian = addPlant(name: "Algerian oak", yearDiscovered: 1809, family: "Fagaceae", scientificName: "Quercus canariensis", imageUrl: "https://bs.floristic.org/image/o/0718714bdba14b284dbf10f05e249bb7489b8467")
        let evergreen = addPlant(name: "Evergreen Oak", yearDiscovered: 1785, family: "Fagaceae", scientificName: "Quercus rotundifolia", imageUrl: "https://bs.floristic.org/image/o/1a03948baf0300da25558c2448f086d39b41ca30")
        let scarlet = addPlant(name: "scarlet oak", yearDiscovered: 1770, family: "Fagaceae", scientificName: "Quercus coccinea", imageUrl: "https://bs.floristic.org/image/o/3e96f72186e9cdaedba5b01bab2d247aa35f3791")
        let _ = addPlantToExhibition(plant: algerian, exhibition: oakCollection)
        let _ = addPlantToExhibition(plant: evergreen, exhibition: oakCollection)
        let _ = addPlantToExhibition(plant: scarlet, exhibition: oakCollection)
        
        let artemisia = addPlant(name: "Artemisia dracunculus", yearDiscovered: 1753, family: "Asteraceae", scientificName: "Artemisia dracunculus", imageUrl: "http://d2seqvvyy3b8p2.cloudfront.net/8e59ec8129f7966d6433dc957f598943.jpg")
        let crithmum = addPlant(name: "Crithmum maritimum", yearDiscovered: 1753, family: "Apiaceae", scientificName: "Crithmum maritimum", imageUrl: "http://d2seqvvyy3b8p2.cloudfront.net/5e77f69531d6c1aafe28520b33dfa513.jpg")
        let sweetBay = addPlant(name: "sweet bay", yearDiscovered: 1753, family: "Lauraceae", scientificName: "Laurus nobilis", imageUrl: "https://bs.floristic.org/image/o/c60e9ebb436b5dd6083a0cfdc6946b3f3b2a1353")
        let _ = addPlantToExhibition(plant: artemisia, exhibition: herbGarden)
        let _ = addPlantToExhibition(plant: crithmum, exhibition: herbGarden)
        let _ = addPlantToExhibition(plant: sweetBay, exhibition: herbGarden)
        
        let bambusa = addPlant(name: "Bambusa balcooa", yearDiscovered: 1832, family: "Poaceae", scientificName: "Bambusa balcooa", imageUrl: "http://d2seqvvyy3b8p2.cloudfront.net/eb8f85dbeed8c2216ce003fe22c25607.jpg")
        let blackBamboo = addPlant(name: "black bamboo", yearDiscovered: 1868, family: "Poaceae", scientificName: "Phyllostachys nigra", imageUrl: "https://bs.floristic.org/image/o/45e7e42c5f9b0a9ec324b9fba3abf970bcfe8ded")
        let xanthorrhoea = addPlant(name: "Xanthorrhoea australis", yearDiscovered: 1810, family: "Asphodelaceae", scientificName: "Xanthorrhoea australis", imageUrl: "https://bs.floristic.org/image/o/c7cd883fcc0bff8642add1dabdb3eac835447a15")
        let _ = addPlantToExhibition(plant: bambusa, exhibition: bambooCollection)
        let _ = addPlantToExhibition(plant: blackBamboo, exhibition: bambooCollection)
        let _ = addPlantToExhibition(plant: xanthorrhoea, exhibition: bambooCollection)
        
        let silverPrincess = addPlant(name: "Silver princess", yearDiscovered: 1867, family: "Myrtaceae", scientificName: "Eucalyptus caesia", imageUrl: "https://bs.floristic.org/image/o/2941f741dbbbdb6bfd59da7dba62b5d4ec6a2881")
        let prideOfMaderia = addPlant(name: "pride of Madeira", yearDiscovered: 1782, family: "Boraginaceae", scientificName: "Echium candicans", imageUrl: "https://bs.floristic.org/image/o/417e90d2c694366815dd6b10db5b7ca91831be2b")
        let spinyThrift = addPlant(name: "Spiny Thrift", yearDiscovered: 1817, family: "Plumbaginaceae", scientificName: "Armeria pungens", imageUrl: "https://bs.floristic.org/image/o/978167f02233fab35050cf5222fd68b21435c776")
        let _ = addPlantToExhibition(plant: silverPrincess, exhibition: waterConservation)
        let _ = addPlantToExhibition(plant: prideOfMaderia, exhibition: waterConservation)
        let _ = addPlantToExhibition(plant: spinyThrift, exhibition: waterConservation)
    }

}

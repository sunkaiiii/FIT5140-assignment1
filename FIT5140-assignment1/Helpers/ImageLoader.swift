//
//  ImageLoader.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 12/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit
import Foundation

final class ImageLoader: NSObject {

    
    private let loaderDelegate = ImageLoaderDelegate()
    
    static let shared:ImageLoader = ImageLoader()
    
    private override init() {
        
    }
    


    func loadImage(_ imageUrl:String, onComplete: @escaping(String, UIImage?)->Void){
        loaderDelegate.loadImage(imageUrl, onComplete: onComplete)
    }
    

    //To encapsulate and hide the interface of the implemented interfaces, using another delegate class.
    private class ImageLoaderDelegate:NSObject,URLSessionTaskDelegate, URLSessionDownloadDelegate{
        private var taskMap = [URLSessionDownloadTask:ImageDownloadTask]()
        private var imageCache = NSCache<AnyObject, AnyObject>()
        private var session:URLSession?
        private let config = URLSessionConfiguration.background(withIdentifier: "ImageLoader")
        
        override init() {
            super.init()
            session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
        }
        
        func loadImage(_ imageUrl:String, onComplete: @escaping(String, UIImage?)->Void){
            guard let session = session else {
                return
            }
            if let data = imageCache.object(forKey: imageUrl as AnyObject){
                onComplete(imageUrl,UIImage(data: data as! Data))
                return
            }
            
            
            if let uiImage = retriveImage(forKey: imageUrl, inStorageType: .fileSystem){
                if let data = uiImage.pngData(){
                    imageCache.setObject(data as AnyObject, forKey: imageUrl as AnyObject)
                }
                onComplete(imageUrl, uiImage)
                return
            }
            
            if let uiImage = UIImage(named: imageUrl){
                if let data = uiImage.pngData(){
                    imageCache.setObject(data as AnyObject, forKey: imageUrl as AnyObject)
                }
                onComplete(imageUrl, uiImage)
            }
            
            guard let url = URL(string: imageUrl) else {
                return
            }
            
            let task = session.downloadTask(with: url)
            taskMap[task] = ImageDownloadTask(imageUrl,onComplete: onComplete)
            task.resume()
        }
        
        
        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
            do{
                let data = try Data(contentsOf: location)
                if let imageTask = taskMap[downloadTask]{
                    imageCache.setObject(data as AnyObject, forKey: imageTask.url as AnyObject)
                    taskMap.removeValue(forKey: downloadTask)
                    let image = UIImage(data: data)
                    if let image = image{
                        storeImage(image: image, forKey: imageTask.url, wtihStorageType: .fileSystem)
                    }
                    DispatchQueue.main.async {
                        imageTask.onComplete(imageTask.url, UIImage(data: data))
                    }
                }
            }catch let error{
                print(error.localizedDescription)
            }
        }
        
        private func storeImage(image:UIImage, forKey key:String, wtihStorageType storageType: StorageType){
            if let pngRepresentation = image.pngData(){
                switch storageType {
                case .fileSystem:
                    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                    let documentDirecotry = paths[0]
                    let fileUrl = documentDirecotry.appendingPathComponent(key)
                    do{
                        try pngRepresentation.write(to: fileUrl)
                    }catch{
                        return
                    }
                    break
                case .userDefaults:
                    UserDefaults.standard.set(pngRepresentation, forKey: key)
                    break
                }
            }
        }
        
        private func retriveImage(forKey key:String, inStorageType storageType: StorageType) -> UIImage? {
            switch storageType {
            case .fileSystem:
                let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                let documentsDirectory = paths[0]
                let imageUrl = documentsDirectory.appendingPathComponent(key)
                let image = UIImage(contentsOfFile: imageUrl.path)
                return image
            case .userDefaults:
                if let imageData = UserDefaults.standard.object(forKey: key) as? Data{
                    return UIImage(data: imageData)
                }
                break
            }
            return nil
        }
    }
    
    private enum StorageType{
        case userDefaults
        case fileSystem
    }
    private class ImageDownloadTask{
        let url:String
        let onComplete:(String,UIImage?)->Void
        
        init(_ url:String, onComplete: @escaping (String,UIImage?)->Void) {
            self.url = url
            self.onComplete = onComplete
        }
    }
}

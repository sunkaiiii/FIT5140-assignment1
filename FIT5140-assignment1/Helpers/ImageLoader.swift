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
    
    static let shraed:ImageLoader = ImageLoader()
    
    private override init() {
        
    }
    

    //TODO Fix http request not handled by the task
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
              let url = URL(string: imageUrl)
              let task = session.downloadTask(with: url!)
              taskMap[task] = ImageDownloadTask(imageUrl,onComplete: onComplete)
              task.resume()
          }
        
        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
            do{
                let data = try Data(contentsOf: location)
                if let imageTask = taskMap[downloadTask]{
                    imageCache.setObject(data as AnyObject, forKey: imageTask.url as AnyObject)
                    taskMap.removeValue(forKey: downloadTask)
                    DispatchQueue.main.async {
                        imageTask.onComplete(imageTask.url, UIImage(data: data))
                    }
                }
            }catch let error{
                print(error.localizedDescription)
            }
        }
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

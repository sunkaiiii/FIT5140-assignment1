//
//  SceneDelegate.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 27/8/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit
import MapKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate,CLLocationManagerDelegate {

    var window: UIWindow?
    let BACKGROUND_LOCATING_KEY = "background_location"
    let locationManger = CLLocationManager()
    
    var regions:Set<CLRegion>?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        locationManger.delegate = self
        locationManger.allowsBackgroundLocationUpdates = true
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        UIApplication.shared.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.databaseController?.cleanup()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        if !UserDefaults.standard.bool(forKey: BACKGROUND_LOCATING_KEY){
            locationManger.startUpdatingLocation()
            if let regions = regions{
                for region in regions{
                    locationManger.startMonitoring(for: region)
                }
            }
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        if !UserDefaults.standard.bool(forKey: BACKGROUND_LOCATING_KEY){
            locationManger.stopUpdatingLocation()
            regions = self.locationManger.monitoredRegions
            if let regions = regions{
                for region in regions{
                    locationManger.stopMonitoring(for: region)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion{
            enterLocation(region: region as! CLCircularRegion)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion{
            exitLocation(region: region as! CLCircularRegion)
        }
    }
    
    
    func enterLocation(region:CLCircularRegion){
        handleEvent(information: "Enter the location",regionName: region.identifier)
    }
    
    func exitLocation(region:CLCircularRegion){
        handleEvent(information: "Exit the location",regionName: region.identifier)
    }
    
    func handleEvent(information:String, regionName:String){
        NotificationHelper.showNotification(controller: self.window?.rootViewController, information: information, regionName: regionName)
    }
}

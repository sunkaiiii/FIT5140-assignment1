//
//  NotificationHelper.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 17/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit
class NotificationHelper{
    static func requestNotificationPermission(){
        let options:UNAuthorizationOptions=[.badge,.sound,.alert]
        UNUserNotificationCenter.current().requestAuthorization(options: options){cuccess,error in
            if let error = error{
                print(error)
                return
            }
        }
    }
    
    static func showNotification(controller:UIViewController?,information:String, regionName:String){
        if UIApplication.shared.applicationState == .active{
            controller?.showToast(message: "\(information) \(regionName)")
        }else{
            let notificationContent = UNMutableNotificationContent()
            notificationContent.body = information+" "+regionName
            notificationContent.sound = UNNotificationSound.default
            notificationContent.badge = UIApplication.shared.applicationIconBadgeNumber+1 as NSNumber
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "location change", content: notificationContent, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
              if let error = error {
                print("Error: \(error)")
              }
            }
        }
    }
}

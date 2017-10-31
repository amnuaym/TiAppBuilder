//
//  AppDelegate.swift
//  MyReminderApp
//
//  Created by DrKeng on 10/15/2560 BE.
//  Copyright © 2560 ANT. All rights reserved.
//

import UIKit
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        UNUserNotificationCenter.current().requestAuthorization(options: <#T##UNAuthorizationOptions#>, completionHandler: <#T##(Bool, Error?) -> Void#>)
        
        // Local Notification do not have Badge. Implemented but not available...
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (accepted, error) in
            if !accepted {
                //This section actually should be implemented as alertController
                print("You did not allow Application Alert")
            }
        }
        
        //Action to be bind to Category
        let mySnoozeAction = UNNotificationAction(identifier: "Snooze60", title: "Snooze for 1 minute", options: [])
        //Category to be bind to Notification
        let myCategory = UNNotificationCategory(identifier: "myCategory", actions: [mySnoozeAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([myCategory])
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func scheduleNotification(myDate : Date){
        // Specify Calendar to use
        let myCalendar = Calendar(identifier: .gregorian)
        //use Thai for Thai Caldendar
        
        //Read Date received and translate into workable componenets
        let components = myCalendar.dateComponents(in: .current, from: myDate)
//        let newComponents = DateComponents(calendar: <#T##Calendar?#>, timeZone: <#T##TimeZone?#>, era: <#T##Int?#>, year: <#T##Int?#>, month: <#T##Int?#>, day: <#T##Int?#>, hour: <#T##Int?#>, minute: <#T##Int?#>, second: <#T##Int?#>, nanosecond: <#T##Int?#>, weekday: <#T##Int?#>, weekdayOrdinal: <#T##Int?#>, quarter: <#T##Int?#>, weekOfMonth: <#T##Int?#>, weekOfYear: <#T##Int?#>, yearForWeekOfYear: <#T##Int?#>)
        let newComponents = DateComponents(calendar: myCalendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        
        //Specify notification as time based noti
        let myTrigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        //Specify Content for notification
        let myContent = UNMutableNotificationContent()
        myContent.title = "MyReminderApp"
        myContent.body = "You have appointment with Doctor at the Hospital"
        myContent.categoryIdentifier = "myCategory"
        myContent.sound = UNNotificationSound.default()
        
        //Add Image into the Notification
        let logoPath = Bundle.main.path(forResource: "logo", ofType: "png")
        let logoURL = URL(fileURLWithPath: logoPath!)
        
        do{
            let imgAttachment = try UNNotificationAttachment(identifier: "logo", url: logoURL, options: nil)
            myContent.attachments = [imgAttachment]
        }catch{
            print("Error: Cannot obtain an image")
        }
        
        let myRequest = UNNotificationRequest(identifier: "textNotification", content: myContent, trigger: myTrigger)
        
        UNUserNotificationCenter.current().delegate = self
        
        //Remove all previous notification to remove duplicate
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(myRequest) { (error) in
            if error != nil{
                print("Error : \(error!)")
            }
        }
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "Snooze60"{
            let newDate = Date(timeInterval: 60, since: Date())
            scheduleNotification(myDate: newDate)
        }
    }
}



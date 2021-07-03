//
//  AppDelegate.swift
//  NotesReminder
//
//  Created by MacBook  on 02.07.21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let center = UNUserNotificationCenter.current()



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        center.requestAuthorization(options: [.alert, .badge, .sound]) { userAcceptedRequest, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if userAcceptedRequest {
                print("user agreed")
            } else {
                print("user disagreed")
            }
        }
        
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


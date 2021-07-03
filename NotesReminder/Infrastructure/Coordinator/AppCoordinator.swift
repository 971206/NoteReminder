//
//  AppCoordinator.swift
//  ReminderWithFileManager_EkaAltunashvili
//
//  Created by MacBook  on 02.07.21.
//

import UIKit
final class AppCoordinator: CoordinatorProtocol {

    //MARK: - Private Properties
    private var window: UIWindow?
    private var navigationController: UINavigationController?
    
    init(_ window: UIWindow?, navigationController: UINavigationController?) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = CategoryViewController.instantiateFromStoryboard()
        vc.coordinator = self
        navigationController?.pushViewController(vc, animated: true)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func proceedToNotes(with categoryURL: URL) {
        let vc = NotesViewController.instantiateFromStoryboard()
        vc.coordinator = self
        vc.categoryURL = categoryURL
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func scheduleNotifications(note: String, hour: String, minute: String) {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = note
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = Int(hour)
        dateComponents.minute = Int(minute)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true )
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    func presentAlert(with message: String) {
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        navigationController?.present(alert, animated: true, completion: nil)
    }
    
}

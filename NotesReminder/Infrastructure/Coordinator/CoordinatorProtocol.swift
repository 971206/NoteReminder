//
//  CoordinatorProtocol.swift
//  ReminderWithFileManager_EkaAltunashvili
//
//  Created by MacBook  on 02.07.21.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
    init(_ window: UIWindow?, navigationController: UINavigationController?)    
    func start()
    func proceedToNotes(with categoryURL: URL)
    func scheduleNotifications(note: String, hour: String, minute: String)
    func presentAlert(with message: String)

}

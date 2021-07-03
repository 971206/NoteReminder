//
//  UiTableView + Extension.swift
//  ReminderWithFileManager_EkaAltunashvili
//
//  Created by MacBook  on 28.06.21.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle.main)
    }
}

extension UITableView {
    func registerClass<T: UITableViewCell>(class: T.Type) {
        self.register(T.self, forCellReuseIdentifier: T.identifier)
    }
    
    func registerNib<T: UITableViewCell>(class: T.Type) {
        self.register(T.nib(), forCellReuseIdentifier: T.identifier)
    }
    
    func registerHeaderFooterNib<T: UIView>(class: T.Type) {
        let name = String(describing: T.self)
        let nib = UINib(nibName: name, bundle: Bundle.main)
        self.register(nib, forHeaderFooterViewReuseIdentifier: name)
    }
    
    func deque<T: UITableViewCell>(_ classType: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
}


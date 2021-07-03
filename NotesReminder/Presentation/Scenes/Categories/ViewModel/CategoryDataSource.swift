//
//  CategoryDataSource.swift
//  ReminderWithFileManager_EkaAltunashvili
//
//  Created by MacBook  on 28.06.21.
//

import UIKit

class CategoryDataSource : NSObject, UITableViewDelegate, UITableViewDataSource {
  
    private var tableView: UITableView!
    private var navigationController: UINavigationController!
    private var controller: CoordinatorDelegate!
    
    var categories: [String]?
    var folderURLs: [URL]?

    
    init(with tableView: UITableView, categories: [String], folderURLs: [URL], navigationController: UINavigationController, controller: CoordinatorDelegate) {
        super.init()

        self.tableView = tableView
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.categories = categories
        self.folderURLs = folderURLs
        self.navigationController = navigationController
        self.controller = controller

    }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return categories?.count ?? 0
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.deque(CategoryCell.self, for: indexPath)
            cell.configure(with: categories?[indexPath.row])
            return cell
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard let folderURL = folderURLs?[indexPath.row] else {return}
            controller.coordinator?.proceedToNotes(with: folderURL)
        }
}


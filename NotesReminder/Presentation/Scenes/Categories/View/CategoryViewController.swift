//
//  CategoryViewController.swift
//  NotesReminder
//
//  Created by MacBook  on 02.07.21.
//

import UIKit

class CategoryViewController: BaseViewController {
    
    
    let fileManager = FileManager.default
    var categories = [String]()
    var folderURLs = [URL]()
    private var dataSource: CategoryDataSource!
    private var documentsDirectoryURL: URL? {
        try? fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
    }

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = CategoryDataSource(with: tableView, categories: categories, folderURLs: folderURLs, navigationController: navigationController!, controller: self)
        tableView.registerNib(class: CategoryCell.self)
        read()
        print(documentsDirectoryURL)
    }
    
    @IBAction func onAdd(_ sender: Any) {
        createCategoryAlert()

    }
    func createCategoryAlert() {
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Add",
                                      style: .cancel,
                                      handler: { action in
                                        guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {return}
                                        self.createCategory(text: text)
                                        
                                      }))
   
        present(alert, animated: true, completion: nil)
    }
    
    func createCategory(text: String) {
        guard let categoryFolderURL = documentsDirectoryURL?.appendingPathComponent(text) else {return}
        try? fileManager.createDirectory(at: categoryFolderURL, withIntermediateDirectories: true, attributes: [:])
        dataSource.categories?.removeAll()
        read()
    }
    func read() {
        do {
            let categoryURLS = try fileManager.contentsOfDirectory(at: documentsDirectoryURL!,
                                                                   includingPropertiesForKeys: nil,
                                                                   options: [.skipsHiddenFiles])
            dataSource.folderURLs? = categoryURLS
            for path in categoryURLS {
                let fileName = path.pathComponents.last
                dataSource.categories?.append(fileName ?? "")
            }
            tableView.reloadData()
        }
        catch {
            print(error.localizedDescription)
        }
    }

}

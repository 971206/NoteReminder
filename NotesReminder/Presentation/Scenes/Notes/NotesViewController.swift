//
//  NotesViewController.swift
//  NotesReminder
//
//  Created by MacBook  on 02.07.21.
//

import UIKit
import UserNotifications

class NotesViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let fileManager = FileManager.default
    private var notesList = [String]()
    private var intervalsList = [String]()
    private var urls = [URL]()
    var categoryURL : URL?
    let center = UNUserNotificationCenter.current()
    let datePicker = UIDatePicker()
    var hours = [String]()
    var minutes = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        center.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        setupTableView()
        readNote()
    }
    
    private func setupTableView() {
        tableView.registerNib(class: NotesCell.self)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    @objc func addTapped() {
        addAlert()
    }
    
    private func createNote(note: String, date: Date) -> String {
        let randomFileName = "\(UUID().uuidString).txt"
        let fileUrl = categoryURL?.appendingPathComponent(randomFileName)
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "hh:mm:ss a"
        let dateFromStr = dateFormater.string(from: date)
        let infoToBeSaved = "\(note) + \(dateFromStr)"
        try? (infoToBeSaved).write(to: fileUrl!, atomically: true, encoding: .utf8)
        notesList = []
        readNote()
        return infoToBeSaved
    }
    
    private func readNote() {
        guard let notesURL = try? fileManager.contentsOfDirectory(at: categoryURL!,
                                                                  includingPropertiesForKeys: nil,
                                                                  options: [.skipsHiddenFiles])  else {return}
        self.urls = notesURL
        
        notesURL.forEach {
            guard let fullNote = (try? String(contentsOf: $0, encoding: .utf8)) else {return}
            let fullNoteList = fullNote.components(separatedBy: "+")
            let note   = fullNoteList[0]
            let interval = fullNoteList[1]
            notesList.append(note)
            intervalsList.append(interval)
            intervalsList.forEach { time in
                let timeComponents = time.components(separatedBy: ":")
                let hour = timeComponents[0]
                let minute = timeComponents[1]
                hours.append(hour)
                minutes.append(minute)
            }
            self.tableView.reloadData()
        }
    }
    
    
    private func updateNote(note: String, date: Date, index: Int) {
        let url = urls[index]
        notesList[index] = note
        let dateFormater = DateFormatter()
        dateFormater.timeZone = NSTimeZone(abbreviation: "GMT+0:00") as TimeZone?
        dateFormater.dateFormat = "hh:mm:ss a"
        let dateFromStr = dateFormater.string(from: date)
        let infoToBeSaved = "\(note) + \(dateFromStr)"
        try? (infoToBeSaved).write(to: url, atomically: false, encoding: .utf8)
        tableView.reloadData()
    }
    
    private func deleteNote(index: Int) {
        guard let notesURL = try? fileManager.contentsOfDirectory(at: categoryURL!,
                                                                  includingPropertiesForKeys: nil,
                                                                  options: [.skipsHiddenFiles])  else {return}
        if notesURL.isEmpty {
            print("empty")
        } else {
            let url = urls[index]
            try? fileManager.removeItem(at: url)
        }
    }
}


extension NotesViewController {
    private func createEditAlert(index: Int) {
        let alert = UIAlertController(title: "Edit Note", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Edit",
                                      style: .cancel,
                                      handler: { action in
                                        guard let fieldNote = alert.textFields?[0], let noteText = fieldNote.text, !noteText.isEmpty else {return}
                                        self.updateNote(note: noteText, date: self.datePicker.date , index: index)
                                      }))
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .time
        alert.view.addSubview(datePicker)
        NSLayoutConstraint.activate([
            alert.view.heightAnchor.constraint(equalToConstant: 200),
            datePicker.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor, constant: -16),
            datePicker.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -50)
        ])
        present(alert, animated: true, completion: nil)
    }
    
    private func addAlert() {
        let alert = UIAlertController(title: "Add New Note", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Add",
                                      style: .cancel,
                                      handler: { action in
                                        guard let fieldNote = alert.textFields?[0], let noteText = fieldNote.text, !noteText.isEmpty else {return}
                                        let newnote = self.createNote(note: noteText, date: self.datePicker.date)
                                        let components = newnote.components(separatedBy: "+")
                                        let time = components[1]
                                        let timeComponents = time.components(separatedBy: ":")
                                        let hour = timeComponents[0]
                                        let minute = timeComponents[1]
                                        self.coordinator?.scheduleNotifications(note: noteText, hour: hour, minute: minute)
                                      }))
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .time
        alert.view.addSubview(datePicker)
        NSLayoutConstraint.activate([
            alert.view.heightAnchor.constraint(equalToConstant: 200),
            datePicker.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor, constant: -16),
            datePicker.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -50)
        ])
        present(alert, animated: true, completion: nil)
    }
    
    
}

extension NotesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.deque(NotesCell.self, for: indexPath)
        cell.configureNote(with: notesList[indexPath.row])
        cell.configureInterval(with: intervalsList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            deleteNote(index: indexPath.row)
            notesList.remove(at: indexPath.row )
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        createEditAlert(index: indexPath.row)
    }
}

extension NotesViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .alert])
    }
}

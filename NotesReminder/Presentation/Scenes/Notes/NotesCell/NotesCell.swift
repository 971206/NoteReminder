//
//  NotesCell.swift
//  NotesReminder
//
//  Created by MacBook  on 02.07.21.
//

import UIKit

class NotesCell: UITableViewCell {

    @IBOutlet weak var labelInterval: UILabel!
    @IBOutlet weak var labelNote: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
       func configureNote(with note: String?) {
        self.labelNote.text = note
       }
    
    func configureInterval(with time: String?) {
     self.labelInterval.text = "Reminder set at \(time ?? "")"
    }
    

}

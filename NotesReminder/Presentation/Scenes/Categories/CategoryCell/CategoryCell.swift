//
//  CategoryCell.swift
//  NotesReminder
//
//  Created by MacBook  on 02.07.21.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var labelCategory: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with category: String?) {
        self.labelCategory.text = category
    }
    
}

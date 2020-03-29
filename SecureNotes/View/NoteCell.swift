//
//  NoteCell.swift
//  SecureNotes
//
//  Created by Fred Lefevre on 2020-03-29.
//  Copyright © 2020 Fred Lefevre. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {

    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var lockImage: UIImageView!
    
    func configureCell(note: Note) {
        if (note.lockStatus == .locked) {
            lockImage.isHidden = false
            messageLabel.text = "This message is locked. Unlock to read."
        } else {
            lockImage.isHidden = true
            messageLabel.text = note.message
        }
    }
    
}

//
//  NoteDetailVC.swift
//  SecureNotes
//
//  Created by Fred Lefevre on 2020-03-29.
//  Copyright © 2020 Fred Lefevre. All rights reserved.
//

import UIKit

class NoteDetailVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    
    var note: NoteCoreData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.text = note?.message ?? "Write something..."
        if (note?.message == nil) {
            textView.textColor = UIColor.lightGray
        } else {
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        if (textView.textColor == UIColor.lightGray) {
            textView.text = nil
            textView.textColor = UIColor.black
        }

        if (textView.text == nil) {
            textView.text = "Write something..."
            textView.textColor = UIColor.lightGray
        }
    }

    @IBAction func lockNotePressed(_ sender: Any) {
        note?.isLocked = true
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if note?.message == nil {
            guard let context = appDelegate?.persistentContainer.viewContext else { return }
            let newNote = NoteCoreData(context: context)
            if textView.text != nil {
                if let message = textView.text {
                    newNote.message = message
                    newNote.isLocked = false
                }
                appDelegate?.saveContext()
            }
        } else {
            if textView.text != nil {
                if let message = textView.text {
                    note?.message = message
                    note?.isLocked = false
                }
                appDelegate?.saveContext()
            }
        }
        
    }
    
}

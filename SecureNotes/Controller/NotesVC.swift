//
//  ViewController.swift
//  SecureNotes
//
//  Created by Fred Lefevre on 2020-03-29.
//  Copyright © 2020 Fred Lefevre. All rights reserved.
//

import UIKit
import LocalAuthentication

class NotesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var notesCoreData: [NoteCoreData] = []
    var isEverythingLocked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getNotes()
    }
    
    func getNotes() {
        guard let context = appDelegate?.persistentContainer.viewContext else { return }
        if let notesFromCoreData = try? context.fetch(NoteCoreData.fetchRequest()) {
            guard let notes = notesFromCoreData as? [NoteCoreData] else { return }
            notesCoreData = notes
            notesCoreData.reverse()
            tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesCoreData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as? NoteCell else { return UITableViewCell() }
        let note = notesCoreData[indexPath.row]
        cell.configureCell(note: note)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if notesCoreData[indexPath.row].isLocked == true {
            authenticateBiometrics { (authenticated) in
                if authenticated {
                    let noteLockStatus = self.notesCoreData[indexPath.row].isLocked
                    self.notesCoreData[indexPath.row].isLocked = lockStatusFlipper(lockStatus: noteLockStatus)
                    DispatchQueue.main.async {
                        self.pushNote(for: indexPath)
                    }
                }
            }
        } else {
            pushNote(for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let context = appDelegate?.persistentContainer.viewContext else { return }
            let note = notesCoreData[indexPath.row]
            context.delete(note)
            appDelegate?.saveContext()
            notesCoreData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func pushNote(for indexPath: IndexPath) {
        guard let noteDetailVC = storyboard?.instantiateViewController(withIdentifier: "NoteDetailVC") as? NoteDetailVC else { return }
        noteDetailVC.note = notesCoreData[indexPath.row]
        navigationController?.pushViewController(noteDetailVC, animated: true)
    }
    
    func authenticateBiometrics(completion: @escaping (Bool) -> Void) {
        let myContext = LAContext()
        let myLocalizedReasonString = "Our app needs to use Touch ID / Face ID to secure your notes."
        var authError: NSError?
        
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { (success, evaluateError) in
                    if success {
                        completion(true)
                    } else {
                        guard let evaluateErrorString = evaluateError?.localizedDescription else { return }
                        self.showAlert(withMessage: evaluateErrorString)
                        completion(false)
                    }
                }
            } else {
                guard let authErrorString = authError?.localizedDescription else { return }
                self.showAlert(withMessage: authErrorString)
                completion(false)
            }
        } else {
            completion(false)
        }
        
    }
    
    func showAlert(withMessage message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(alertAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    func flipEveryNoteLockStatus() {
        for note in self.notesCoreData {
            let lockStatus = note.isLocked
            note.isLocked = lockStatusFlipper(lockStatus: lockStatus)
        }
    }

    @IBAction func lockEverythingPressed(_ sender: Any) {
        flipEveryNoteLockStatus()
        isEverythingLocked = !isEverythingLocked
        if !isEverythingLocked {
            authenticateBiometrics { (authenticated) in
                if authenticated {
                    self.flipEveryNoteLockStatus()
                }
            }
        }
        appDelegate?.saveContext()
        tableView.reloadData()
    }
}


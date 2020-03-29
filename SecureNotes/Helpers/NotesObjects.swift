//
//  NotesObjects.swift
//  SecureNotes
//
//  Created by Fred Lefevre on 2020-03-29.
//  Copyright © 2020 Fred Lefevre. All rights reserved.
//

import Foundation

var note1 = Note(message: "Really cool notes app", lockStatus: .unlocked)
var note2 = Note(message: "RPG game, chess game, uber clone", lockStatus: .locked)
var note3 = Note(message: "Trump is an idiot.", lockStatus: .unlocked)

var notes: [Note] = [note1, note2, note3]

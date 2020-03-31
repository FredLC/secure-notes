//
//  Helpers.swift
//  SecureNotes
//
//  Created by Fred Lefevre on 2020-03-29.
//  Copyright © 2020 Fred Lefevre. All rights reserved.
//

import Foundation


func lockStatusFlipper(lockStatus: Bool) -> Bool {
    if lockStatus == true {
        return false
    } else {
        return true
    }
}

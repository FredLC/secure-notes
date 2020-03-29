//
//  Helpers.swift
//  SecureNotes
//
//  Created by Fred Lefevre on 2020-03-29.
//  Copyright © 2020 Fred Lefevre. All rights reserved.
//

import Foundation

func isLocked(lockStatus: LockStatus) -> Bool {
    if lockStatus == .locked {
        return true
    } else {
        return false
    }
}

func lockStatusFlipper(lockStatus: LockStatus) -> LockStatus {
    if lockStatus == .locked {
        return .unlocked
    } else {
        return .locked
    }
}

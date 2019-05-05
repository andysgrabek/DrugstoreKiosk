//
//  DetectedConflicts.swift
//  Drugstore
//
//  Created by Andrzej Grabowski on 06/01/2019.
//  Copyright © 2019 Andrzej Grabowski. All rights reserved.
//

import Foundation

class DetectedConflicts {
    
    static var conflicts = [Conflict]()
    
    static func clear() {
        conflicts.removeAll()
    }
}

//
//  Report.swift
//  Drugstore
//
//  Created by Andrzej Grabowski on 18/01/2019.
//  Copyright © 2019 Andrzej Grabowski. All rights reserved.
//

import Foundation

class Report: Codable {
    
    init(recipient: String, locale: String, conflicts: [Conflict]) {
        self.recipient = recipient
        self.locale = locale
        self.conflicts = conflicts
    }
    
    var recipient: String?
    var locale: String?
    var conflicts: [Conflict]?
}

//
//  SelectedDrugs.swift
//  Drugstore
//
//  Created by Andrzej Grabowski on 01/01/2019.
//  Copyright © 2019 Andrzej Grabowski. All rights reserved.
//

import Foundation

class SelectedDrugs {
    
    static var drugs = [Drug]()
    
    static func clear() {
        drugs.removeAll()
    }
    
}

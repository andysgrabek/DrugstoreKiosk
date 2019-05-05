//
//  Drug.swift
//  Drugstore
//
//  Created by Andrzej Grabowski on 29/12/2018.
//  Copyright © 2018 Andrzej Grabowski. All rights reserved.
//

import Foundation
import ObjectMapper

class Drug: Codable {
    
    var code: String?
    var name: String?
    var substance: String?
    
    required init?(map: Map) {
        
    }
    
    init(code: String, name: String, substance: String) {
        self.code = code
        self.name = name
        self.substance = substance
    }
    
}

extension Drug: CustomStringConvertible {
    
    var description: String {
        return "Drug: \(name) \(code) \(substance)"
    }
    
}

extension Drug: Mappable {
    
    func mapping(map: Map) {
        code <- map["code"]
        name <- map["name"]
        substance <- map["substance"]
    }
    
}

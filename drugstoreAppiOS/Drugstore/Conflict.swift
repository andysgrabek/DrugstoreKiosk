//
//  Conflict.swift
//  Drugstore
//
//  Created by Andrzej Grabowski on 29/12/2018.
//  Copyright © 2018 Andrzej Grabowski. All rights reserved.
//

import Foundation
import ObjectMapper

class Conflict: Codable {
    
    var LHS: Drug?
    var RHS: Drug?
    var descriptionText: String?
    
    required init?(map: Map) {
        
    }
    
    init(LHS: Drug, RHS: Drug, cause: String, descriptionText: String) {
        self.LHS = LHS
        self.RHS = RHS
        self.descriptionText = descriptionText
    }
    
}

extension Conflict: CustomStringConvertible {
    
    var description: String {
        return "Conflict between \(LHS) and \(RHS) - \(descriptionText)"
    }
    
}

extension Conflict: Mappable {
    
    
    func mapping(map: Map) {
        LHS <- map["LHS"]
        RHS <- map["RHS"]
        descriptionText <- map["descriptionText"]
    }
    
}


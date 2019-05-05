//
//  TranslationReq.swift
//  Drugstore
//
//  Created by Andrzej Grabowski on 18/01/2019.
//  Copyright © 2019 Andrzej Grabowski. All rights reserved.
//

import Foundation

class TranslationReq: Codable {
    
    var targetLang: String?
    var text: String?
    
    init(text: String, targetLang: String) {
        self.text = text
        self.targetLang = targetLang
    }
}

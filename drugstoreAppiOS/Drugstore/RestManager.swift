//
//  RestManager.swift
//  Drugstore
//
//  Created by Andrzej Grabowski on 29/12/2018.
//  Copyright © 2018 Andrzej Grabowski. All rights reserved.
//

import Foundation
import Alamofire

class RestManager {
    
    //App Service REST API base url
    private static let url = Bundle.main.object(forInfoDictionaryKey: "drugstoreEndpoint") as! String
    let baseURL: URL
    static let shared = RestManager(baseURL: URL(string: url)!)
    
    /**
     Constructs the RestManager singleton
     
     - Parameter baseURL: URL to be used as base URL for the REST API
     
    */
    private init(baseURL: URL) {
        self.baseURL = baseURL.appendingPathComponent("/api/v1/drugs")
    }
    /**
     Retrieves the drug.
     
     - Parameter ean: the code of the drug being checked for its name in the database.
     
     - Returns: A DataRequest object.
     */
    func getDrug(ean: String) -> DataRequest {
        return Alamofire.request(baseURL.appendingPathComponent("getDrug").absoluteURL, method: .get, parameters: ["ean": ean])
    }
    
    /**
     Requests the list of conflicts between selected drugs.
     
     - Parameter drugs: An array of Drug objects
     
     - Returns: A DataRequest object.
     */
    func getConflicts(drugs: [Drug]) -> DataRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent("getConflicts").absoluteURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try! JSONEncoder().encode(drugs)
        request.httpBody = jsonData
        return Alamofire.request(request)
    }
    
    /**
     Requests sending a report to the user-entered email address about detected conflicts in a given language
     
     - Parameter address: email address of the recipient.
     - Parameter conflicts: conflicts to be transformed into a report
     - Parameter locale: message target language
     
     - Returns: A DataRequest object.
     */
    func sendReport(address: String, conflicts: [Conflict], locale: String) -> DataRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent("sendReport").absoluteURL)
        let report = Report(recipient: address, locale: locale, conflicts: conflicts)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try! JSONEncoder().encode(report)
        request.httpBody = jsonData
        return Alamofire.request(request)
        
    }
    
    /**
     Requests translation of a text to a given targetLang
     
     - Parameter text: text to be translated
     - Parameter targetLang: target language
     
     - Returns: A DataRequest object.
     */
    func getTranslation(text: String, targetLang: String) -> DataRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent("getTranslation").absoluteURL)
        let translationReq = TranslationReq(text: text, targetLang: targetLang)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try! JSONEncoder().encode(translationReq)
        request.httpBody = jsonData
        return Alamofire.request(request)
    }
    
    /**
     Request to check server availability
     
     - Returns: A DataRequest object.
     */
    func getServer() -> DataRequest {
        return Alamofire.request(RestManager.url)
    }
    
}

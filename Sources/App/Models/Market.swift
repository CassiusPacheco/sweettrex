//
//  Market.swift
//  sweettrex
//
//  Created by Cassius Pacheco on 23/9/17.
//
//

import Foundation
import HTTP

struct Market: JSONInitializable {
    
    let name: String
    let description: String
    let isActive: Bool
    
    init(name: String, description: String, isActive: Bool = true) {
        
        self.name = name
        self.description = description
        self.isActive = isActive
    }
    
    init(json: JSON) throws {
        
        guard let base: String = try json.get("BaseCurrencyLong"), let currency: String = try json.get("MarketCurrencyLong") else { throw Abort.badRequest }
        
        self.name = try json.get("MarketName")
        self.isActive = try json.get("IsActive")
        self.description = base + "-" + currency
    }
}

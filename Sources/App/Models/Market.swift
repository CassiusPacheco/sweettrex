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
    let isActive: Bool
    
    init(name: String, isActive: Bool = true) {
        
        self.name = name
        self.isActive = isActive
    }
    
    init(json: JSON) throws {
        
        self.name = try json.get("MarketName")
        self.isActive = try json.get("IsActive")
    }
}

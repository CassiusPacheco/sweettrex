//
//  Market.swift
//  sweettrex
//
//  Created by Cassius Pacheco on 23/9/17.
//
//

import Foundation
import FluentProvider
import HTTP

final class Market: Model {
    
    let storage = Storage()
    
    let name: String
    let description: String
    let isActive: Bool
    
    init(name: String, description: String, isActive: Bool = true) {
        
        self.name = name
        self.description = description
        self.isActive = isActive
    }
    
    required init(row: Row) throws {
        
        name = try row.get(Market.Keys.name)
        description = try row.get(Market.Keys.description)
        isActive = try row.get(Market.Keys.isActive)
    }
    
    init(json: JSON) throws {
        
        guard let base: String = try json.get("BaseCurrencyLong"), let currency: String = try json.get("MarketCurrencyLong") else { throw Abort.badRequest }
        
        self.name = try json.get("MarketName")
        self.isActive = try json.get("IsActive")
        self.description = base + "-" + currency
    }
    
    func makeRow() throws -> Row {
        
        var row = Row()
        
        try row.set(Market.Keys.name, name)
        try row.set(Market.Keys.description, description)
        try row.set(Market.Keys.isActive, isActive)
        
        return row
    }
}

extension Market: Timestampable { }

extension Market: Preparation {
    
    static func prepare(_ database: Database) throws {
        
        try database.create(self) { builder in
            
            builder.id()
            builder.string(Market.Keys.name)
            builder.string(Market.Keys.description)
            builder.bool(Market.Keys.isActive)
        }
    }
    
    static func revert(_ database: Database) throws {
        
        try database.delete(self)
    }
}

extension Market {
    
    fileprivate struct Keys {
        
        static var name = "name"
        static var description = "description"
        static var isActive = "is_active"
    }
}
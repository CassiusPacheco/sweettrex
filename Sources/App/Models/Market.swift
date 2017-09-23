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
    var lastPrice: Double?

    required init(row: Row) throws {
        
        name = try row.get(Market.Keys.name)
        description = try row.get(Market.Keys.description)
        isActive = try row.get(Market.Keys.isActive)
        lastPrice = try row.get(Market.Keys.lastPrice)
    }
    
    init(json: JSON) throws {
        
        guard let base: String = try json.get("BaseCurrencyLong"), let currency: String = try json.get("MarketCurrencyLong") else { throw Abort.badRequest }
        
        let name: String = try json.get("MarketName")
        
        self.name = name.uppercased()
        self.isActive = try json.get("IsActive")
        self.description = base + "-" + currency
    }
    
    func makeRow() throws -> Row {
        
        var row = Row()
        
        try row.set(Market.Keys.name, name)
        try row.set(Market.Keys.description, description)
        try row.set(Market.Keys.isActive, isActive)
        try row.set(Market.Keys.lastPrice, lastPrice)
        
        return row
    }
}

extension Market: JSONRepresentable {
    
    func makeJSON() throws -> JSON {
        
        var json = JSON()
        
        try json.set(Market.Keys.name, name)
        try json.set(Market.Keys.description, description)
        try json.set(Market.Keys.isActive, isActive)
        
        return json
    }
}

extension Market: Timestampable { }

extension Market: Preparation {
    
    static func prepare(_ database: Database) throws {
        
        try database.create(self) { builder in
            
            builder.id()
            builder.string(Market.Keys.name, unique: true)
            builder.string(Market.Keys.description)
            builder.bool(Market.Keys.isActive)
            builder.double(Market.Keys.lastPrice, optional: true)
        }
    }
    
    static func revert(_ database: Database) throws {
        
        try database.delete(self)
    }
}

extension Market {
    
    static func findOr404(byName name: String) throws -> Market {
        
        guard let market = try Market.makeQuery().filter(Market.Keys.name, name).first() else { throw ModelNotFoundError(type: Market.self) }
        
        return market
    }
    
    static func find(byName name: String) throws -> Market? {
        
        return try Market.makeQuery().filter(Market.Keys.name, name).first()
    }
}

extension Market {
    
    fileprivate struct Keys {
        
        static var name = "name"
        static var description = "description"
        static var isActive = "is_active"
        static var lastPrice = "last_price"
    }
}

extension Market: Equatable {
    
    static func ==(lhs: Market, rhs: Market) -> Bool {
        
        guard lhs.name == rhs.name else { return false }
        guard lhs.description == rhs.description else { return false }
        guard lhs.isActive == rhs.isActive else { return false }
        guard lhs.lastPrice == rhs.lastPrice else { return false }
        
        return true
    }
}

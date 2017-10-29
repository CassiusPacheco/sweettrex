//
//  Alert.swift
//  sweettrex
//
//  Created by Cassius Pacheco on 23/9/17.
//
//

import Foundation
import FluentProvider
import HTTP

final class Alert: Model {
    
    let storage = Storage()
    
    let email: String
    let market: Market
    let price: Double
    var repeatCount: Int

    required init(row: Row) throws {
        
        guard let name: String = try row.get(Alert.Keys.market) else { throw Abort.badRequest }
        
        self.market = try Market.findOr404(byName: name)
        self.email = try row.get(Alert.Keys.email)
        self.price = try row.get(Alert.Keys.price)
        self.repeatCount = try row.get(Alert.Keys.repeatCount)
    }
    
    init(json: JSON) throws {
        
        guard let name: String = try json.get(Alert.Keys.market) else { throw Abort.badRequest }
        
        self.market = try Market.findOr404(byName: name)
        self.email = try json.get(Alert.Keys.email)
        self.price = try json.get(Alert.Keys.price)
        
        let count: Int? = try json.get(Alert.Keys.repeatCount)
        self.repeatCount = count ?? 0
    }
    
    func makeRow() throws -> Row {
        
        var row = Row()
        
        try row.set(Alert.Keys.email, email)
        try row.set(Alert.Keys.market, market.name)
        try row.set(Alert.Keys.price, price)
        try row.set(Alert.Keys.repeatCount, repeatCount)
        
        return row
    }
}

extension Alert: JSONRepresentable {
    
    func makeJSON() throws -> JSON {
        
        var json = JSON()
        
        try json.set(Alert.Keys.email, email)
        try json.set(Alert.Keys.market, market.name)
        try json.set(Alert.Keys.price, price)
        try json.set(Alert.Keys.repeatCount, repeatCount)
        
        return json
    }
}

extension Alert {
    
    static func findAll(byEmail email: String) throws -> [Alert] {
        
        return try Alert.makeQuery().filter(Alert.Keys.email, email).all()
    }
}

extension Alert: Timestampable { }

extension Alert: Preparation {
    
    static func prepare(_ database: Database) throws {
        
        try database.create(self) { builder in
            
            builder.id()
            builder.string(Alert.Keys.email)
            builder.string(Alert.Keys.market)
            builder.double(Alert.Keys.price)
            builder.integer(Alert.Keys.repeatCount)
            builder.foreignKey(Alert.Keys.market, references: Alert.Keys.marketForeignKey, on: Market.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        
        try database.delete(self)
    }
}

extension Alert {
    
    fileprivate struct Keys {
        
        static var email = "email"
        static var market = "market"
        static var price = "price"
        static var marketForeignKey = "name"
        static var repeatCount = "repeat_count"
    }
}


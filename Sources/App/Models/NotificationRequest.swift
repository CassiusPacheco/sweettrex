//
//  NotificationRequest.swift
//  sweettrex
//
//  Created by Cassius Pacheco on 23/9/17.
//
//

import Foundation
import FluentProvider
import HTTP

final class NotificationRequest: Model {
    
    let storage = Storage()
    
    let email: String
    let market: Market
    let price: Double
    var repeatCount: Int

    required init(row: Row) throws {
        
        guard let name: String = try row.get(NotificationRequest.Keys.market) else { throw Abort.badRequest }
        
        self.market = try Market.findOr404(byName: name)
        self.email = try row.get(NotificationRequest.Keys.email)
        self.price = try row.get(NotificationRequest.Keys.price)
        self.repeatCount = try row.get(NotificationRequest.Keys.repeatCount)
    }
    
    init(json: JSON) throws {
        
        guard let name: String = try json.get(NotificationRequest.Keys.market) else { throw Abort.badRequest }
        
        self.market = try Market.findOr404(byName: name)
        self.email = try json.get(NotificationRequest.Keys.email)
        self.price = try json.get(NotificationRequest.Keys.price)
        
        let count: Int? = try json.get(NotificationRequest.Keys.repeatCount)
        self.repeatCount = count ?? 0
    }
    
    func makeRow() throws -> Row {
        
        var row = Row()
        
        try row.set(NotificationRequest.Keys.email, email)
        try row.set(NotificationRequest.Keys.market, market.name)
        try row.set(NotificationRequest.Keys.price, price)
        try row.set(NotificationRequest.Keys.repeatCount, repeatCount)
        
        return row
    }
}

extension NotificationRequest: JSONRepresentable {
    
    func makeJSON() throws -> JSON {
        
        var json = JSON()
        
        try json.set(NotificationRequest.Keys.email, email)
        try json.set(NotificationRequest.Keys.market, market.name)
        try json.set(NotificationRequest.Keys.price, price)
        try json.set(NotificationRequest.Keys.repeatCount, repeatCount)
        
        return json
    }
}

extension NotificationRequest {
    
    static func findAll(byEmail email: String) throws -> [NotificationRequest] {
        
        return try NotificationRequest.makeQuery().filter(NotificationRequest.Keys.email, email).all()
    }
}

extension NotificationRequest: Timestampable { }

extension NotificationRequest: Preparation {
    
    static func prepare(_ database: Database) throws {
        
        try database.create(self) { builder in
            
            builder.id()
            builder.string(NotificationRequest.Keys.email)
            builder.string(NotificationRequest.Keys.market)
            builder.double(NotificationRequest.Keys.price)
            builder.integer(NotificationRequest.Keys.repeatCount)
            builder.foreignKey(NotificationRequest.Keys.market, references: NotificationRequest.Keys.marketForeignKey, on: Market.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        
        try database.delete(self)
    }
}

extension NotificationRequest {
    
    fileprivate struct Keys {
        
        static var email = "email"
        static var market = "market"
        static var price = "price"
        static var marketForeignKey = "name"
        static var repeatCount = "repeat_count"
    }
}


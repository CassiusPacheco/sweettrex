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
    let lowPrice: Double?
    let highPrice: Double?

    required init(row: Row) throws {
        
        email = try row.get(NotificationRequest.Keys.email)
        market = try row.get(NotificationRequest.Keys.market)
        lowPrice = try row.get(NotificationRequest.Keys.lowPrice)
        highPrice = try row.get(NotificationRequest.Keys.highPrice)
    }
    
    init(json: JSON) throws {
        
        guard let name: String = try json.get(NotificationRequest.Keys.market) else { throw Abort.badRequest }
        
        self.market = try Market.findOr404(byName: name)
        self.email = try json.get(NotificationRequest.Keys.email)
        self.lowPrice = try json.get(NotificationRequest.Keys.lowPrice)
        self.highPrice = try json.get(NotificationRequest.Keys.highPrice)
        
        guard self.lowPrice != nil || self.highPrice != nil else { throw Abort.badRequest }
    }
    
    func makeRow() throws -> Row {
        
        var row = Row()
        
        try row.set(NotificationRequest.Keys.email, email)
        try row.set(NotificationRequest.Keys.marketName, market)
        try row.set(NotificationRequest.Keys.lowPrice, lowPrice)
        try row.set(NotificationRequest.Keys.highPrice, highPrice)
        
        return row
    }
}

extension NotificationRequest: Timestampable { }

extension NotificationRequest: Preparation {
    
    static func prepare(_ database: Database) throws {
        
        try database.create(self) { builder in
            
            builder.id()
            builder.string(NotificationRequest.Keys.email)
            builder.string(NotificationRequest.Keys.market)
            builder.foreignKey(NotificationRequest.Keys.market, references: NotificationRequest.Keys.marketForeignKey, on: Market.self)
            builder.double(NotificationRequest.Keys.lowPrice, optional: true)
            builder.double(NotificationRequest.Keys.highPrice, optional: true)
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
        static var lowPrice = "low_price"
        static var highPrice = "high_price"
        static var marketForeignKey = "name"
    }
}


//
//  MarketController.swift
//  sweettrex
//
//  Created by Cassius Pacheco on 23/9/17.
//
//

import Vapor
import HTTP

final class MarketController {
    
    func market(_ request: Request) throws -> ResponseRepresentable {
        
        return try Market.all().makeJSON()
    }
}

extension MarketController: EmptyInitializable { }

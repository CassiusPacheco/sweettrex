//
//  Ticker.swift
//  sweettrex
//
//  Created by Cassius Pacheco on 23/9/17.
//
//

import Foundation

struct Ticker {
    
    let market: Market
    let lastPrice: Double

    init(market: Market, lastPrice: Double) {
        
        self.market = market
        self.lastPrice = lastPrice
    }
}

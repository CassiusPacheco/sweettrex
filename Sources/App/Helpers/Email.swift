//
//  Email.swift
//  sweettrex
//
//  Created by Cassius Pacheco on 24/9/17.
//
//

import Foundation
import SMTP

extension Email {
    
    convenience init(alert: Alert, market: Market, currentPrice: Double) throws {
        
        guard let lastPrice = market.lastPrice else { throw Abort.badRequest }
        
        self.init(from: EmailAddress(name: "Sweettrex", address: "sweettrex@sweettrex.com"),
                  to: alert.email,
                  subject: "[\(market.name)] Price alert",
            body: "\(market.description) crossing price \(alert.price)\n\nFrom \(lastPrice) to \(currentPrice)")
    }
}

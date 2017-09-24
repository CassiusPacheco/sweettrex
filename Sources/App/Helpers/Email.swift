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
    
    convenience init(notification: NotificationRequest, market: Market, currentPrice: Double) throws {
        
        guard let lastPrice = market.lastPrice else { Abort.badRequest }
        
        self.init(from: EmailAddress(name: "Sweettrex", address: "sweettrex@sweettrex.com"),
                  to: notification.email,
                  subject: "[\(market.name)] Price alert",
            body: "\(market.description) crossing price \(notification.price)\n\nFrom \(lastPrice) to \(currentPrice)")
    }
}

//
//  NotificationRequestJob.swift
//  sweettrex
//
//  Created by Cassius Pacheco on 24/9/17.
//
//

import Foundation

struct NotificationRequestJob {
    
    private let service: TickerServiceProtocol
    
    init() {
        
        self.init(service: TickerService())
    }
    
    init(service: TickerServiceProtocol) {
        
        self.service = service
    }
    
    func checkNotification() {
        
        do {
            
            print("\nCheck notifications...")
            
            let notifications = try NotificationRequest.all()
            
            let uniqueMarkets = notifications.map({ $0.market }).filterDuplicates(includeElement: ==)
            
            for market in uniqueMarkets {
                
                try service.tick(market) { result in
                    
                    if case .successful(let ticker) = result {
                        
                        try? self.updateMarketAndNotifyIfNecessary(market, price: ticker.lastPrice, notifications: notifications)
                        
                        print("\n [\(market.name)] finished at \(ticker.lastPrice)")
                    }
                }
            }
        }
        catch let error {
            
            // TODO: handle errors
            print("failed to check notifications \(error)")
        }
    }
    
    func updateMarketAndNotifyIfNecessary(_ market: Market, price: Double, notifications: [NotificationRequest]) throws {
        
        guard market.lastPrice != price else { return }
        
        if let lastPrice = market.lastPrice {
            
            let marketNotifications = notifications.filter({ $0.market == market })
            
            for notification in marketNotifications {
                
                guard (price > notification.price && lastPrice < notification.price) ||
                    (price < notification.price && lastPrice > notification.price) else { continue }
                
                print("\n✉️ [\(market.name)] Notify \(notification.email) crossing price \(notification.price) from (\(lastPrice) to \(price))\n")
                
                //TODO: send email
            }
        }
        
        market.lastPrice = price
        try market.save()
    }
}

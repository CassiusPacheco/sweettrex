//
//  NotificationRequestJob.swift
//  sweettrex
//
//  Created by Cassius Pacheco on 24/9/17.
//
//

import Foundation
import SMTP

struct NotificationRequestJob {
    
    private let service: TickerServiceProtocol
    
    private let mail: MailProtocol
    
    init(droplet: Droplet) throws {
        
        self.init(service: TickerService(), mail: try Mailgun(config: droplet.config))
    }
    
    init(service: TickerServiceProtocol, mail: MailProtocol) {
        
        self.service = service
        self.mail = mail
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
    
    func updateMarketAndNotifyIfNecessary(_ market: Market, price currentPrice: Double, notifications: [NotificationRequest]) throws {
        
        guard market.lastPrice != currentPrice else { return }
        
        if let lastPrice = market.lastPrice {
            
            let marketNotifications = notifications.filter({ $0.market == market })
            
            for notification in marketNotifications {
                
                guard (currentPrice > notification.price && lastPrice < notification.price) ||
                    (currentPrice < notification.price && lastPrice > notification.price) else { continue }
                
                print("\n✉️ [\(market.name)] Notify \(notification.email) crossing price \(notification.price) from \(lastPrice) to \(currentPrice)\n")
                
                do {
                    
                    let email = try Email(notification: notification, market: market, currentPrice: currentPrice)
                    
                    try self.mail.send(email)
                    
                    if notification.repeatCount == 0 {
                        
                        try notification.delete()
                    }
                    else {
                        
                        notification.repeatCount -= 1
                        try notification.save()
                    }
                }
                catch let error {
                    
                    print("💥📩💥 Failed to send email to \(notification.email): \(error)")
                }
            }
        }
        
        market.lastPrice = currentPrice
        try market.save()
    }
}

//
//  AlertJob.swift
//  sweettrex
//
//  Created by Cassius Pacheco on 24/9/17.
//
//

import Foundation
import SMTP

struct AlertJob {
    
    private let service: TickerServiceProtocol
    
    private let mail: MailProtocol
    
    init(droplet: Droplet) throws {
        
        self.init(service: TickerService(), mail: try Mailgun(config: droplet.config))
    }
    
    init(service: TickerServiceProtocol, mail: MailProtocol) {
        
        self.service = service
        self.mail = mail
    }
    
    func checkAlert() {
        
        do {
            
            print("\nChecking alerts...")
            
            let alerts = try Alert.all()
            
            let uniqueMarkets = alerts.map({ $0.market }).filterDuplicates(includeElement: ==)
            
            for market in uniqueMarkets {
                
                DispatchQueue.global().async {
                    
                    guard let result = try? self.service.tick(market) else {
                        
                        return print("[AlertJob] Tick failed")
                    }
                    
                    if case .successful(let ticker) = result {
                        
                        try? self.updateMarketAndNotifyIfNecessary(market, price: ticker.lastPrice, alerts: alerts)
                        
                        print("\n [AlertJob] - [\(market.name)] finished at \(ticker.lastPrice)")
                    }
                }
            }
        }
        catch let error {
            
            // TODO: handle errors
            print("failed to check alerts \(error)")
        }
    }
    
    func updateMarketAndNotifyIfNecessary(_ market: Market, price currentPrice: Double, alerts: [Alert]) throws {
        
        guard market.lastPrice != currentPrice else { return }
        
        if let lastPrice = market.lastPrice {
            
            let marketAlerts = alerts.filter({ $0.market == market })
            
            for alert in marketAlerts {
                
                guard (currentPrice > alert.price && lastPrice < alert.price) ||
                    (currentPrice < alert.price && lastPrice > alert.price) else { continue }
                
                print("\n✉️ [\(market.name)] Notify \(alert.email) crossing price \(alert.price) from \(lastPrice) to \(currentPrice)\n")
                
                do {
                    
                    let email = try Email(alert: alert, market: market, currentPrice: currentPrice)
                    
                    try self.mail.send(email)
                    
                    if alert.repeatCount == 0 {
                        
                        try alert.delete()
                    }
                    else {
                        
                        alert.repeatCount -= 1
                        try alert.save()
                    }
                }
                catch let error {
                    
                    print("💥📩💥 Failed to send email to \(alert.email): \(error)")
                }
            }
        }
        
        market.lastPrice = currentPrice
        try market.save()
    }
}

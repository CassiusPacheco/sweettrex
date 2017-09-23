//
//  MarketJob.swift
//  sweettrex
//
//  Created by Cassius Pacheco on 23/9/17.
//
//

import Foundation

struct MarketJob {
    
    private let service: MarketServiceProtocol
    
    init() {
        
        self.init(service: MarketService())
    }
    
    init(service: MarketServiceProtocol) {
        
        self.service = service
    }
    
    func fetchAndSaveMarkets() {
        
        do {
        
            print("\nFetching markets...")
            
            try service.allMarkets { result in
                
                if case .successful(let markets) = result {
                    
                    try? markets.forEach({ try $0.save() })
                }
            }
        }
        catch {
            
            // TODO: handle errors
            print("failed to request markets")
        }
    }
}

//
//  MarketJob.swift
//  sweettrex
//
//  Created by Cassius Pacheco on 23/9/17.
//
//

import Foundation

struct MarketJob {
    
    private let service: HttpServiceProtocol
    
    init() {
        
        self.init(httpService: HttpService())
    }
    
    init(httpService: HttpServiceProtocol) {
        
        self.service = httpService
    }
    
    func fetchAndSaveMarkets() {
        
        do {
        
            print("\nFetching markets...")
            
            try service.request(.market, httpMethod: .GET, bodyData: nil) { result in
                
                switch result {
                    
                case .successful(let json):
                    
                    do {
                    
                        try self.parseAndSave( json)
                    }
                    catch {
                        
                        // TODO: handle errors
                        print("💥 failed to parse and save markets")
                    }
                    
                case .failed(let error):
                    
                    // TODO: handle errors
                    print(error)
                }
            }
        }
        catch {
            
            // TODO: handle errors
            print("failed to request markets")
        }
    }
    
    func parseAndSave(_ json: JSON) throws {
        
        guard let marketsJSON: [JSON] = try json.get("result") else { throw Abort.badRequest }
        
        let markets = try marketsJSON.map({ try Market(json: $0) })
        
        for market in markets {
            
            if let dbMarket = try Market.find(byName: market.name) {
                
                market.id = dbMarket.id
                market.exists = true
            }
            
            try market.save()
        }
        
        print("Markets saved\n")
    }
}

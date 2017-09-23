//
//  MarketService.swift
//  sweettrex
//
//  Created by Cassius Pacheco on 24/9/17.
//
//

import Foundation

protocol MarketServiceProtocol {
    
    func allMarkets(onCompletion: @escaping (Result<[Market]>) -> Void) throws
}

struct MarketService: MarketServiceProtocol {

    private let service: HttpServiceProtocol
    
    init() {
        
        self.init(httpService: HttpService())
    }
    
    init(httpService: HttpServiceProtocol) {
        
        self.service = httpService
    }
    
    func allMarkets(onCompletion: @escaping (Result<[Market]>) -> Void) throws {
        
        do {
            
            print("\nFetching markets...")
            
            try service.request(.market, httpMethod: .GET, bodyData: nil) { result in
                
                switch result {
                    
                case .successful(let json):
                    
                    do {
                        
                        let markets = try self.parse(json)
                        
                        onCompletion(.successful(markets))
                    }
                    catch {
                        
                        // TODO: handle errors
                        print("💥 failed to parse and save markets")
                        onCompletion(.failed(.parsing))
                    }
                    
                case .failed(let error):
                    
                    // TODO: handle errors
                    print(error)
                    onCompletion(.failed(.unknown))
                }
            }
        }
        catch {
            
            // TODO: handle errors
            print("failed to request markets")
            onCompletion(.failed(.unknown))
        }
    }
    
    func parse(_ json: JSON) throws -> [Market] {
        
        guard let marketsJSON: [JSON] = try json.get("result") else { throw Abort.badRequest }
        
        let markets = try marketsJSON.map({ try Market(json: $0) })
        
        for market in markets {
            
            guard let dbMarket = try Market.find(byName: market.name) else { continue }
            
            market.id = dbMarket.id
            market.exists = true
        }
        
        return markets
    }
}

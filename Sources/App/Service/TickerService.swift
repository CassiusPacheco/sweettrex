//
//  TickerService.swift
//  sweettrex
//
//  Created by Cassius Pacheco on 24/9/17.
//
//

import Foundation

protocol TickerServiceProtocol {
    
    func tick(_ market: Market, onCompletion: @escaping (Result<Ticker>) -> Void) throws
}

struct TickerService: TickerServiceProtocol {
    
    private let service: HttpServiceProtocol
    
    init() {
        
        self.init(httpService: HttpService())
    }
    
    init(httpService: HttpServiceProtocol) {
        
        self.service = httpService
    }
    
    func tick(_ market: Market, onCompletion: @escaping (Result<Ticker>) -> Void) throws {
        
        do {
            
            print("\nTick \(market.name)...")
            
            try service.request(.ticker(market), httpMethod: .GET, bodyData: nil) { result in
                
                switch result {
                    
                case .successful(let json):
                    
                    do {
                        
                        let tick = try self.parse(json, for: market)
                        
                        onCompletion(.successful(tick))
                    }
                    catch {
                        
                        // TODO: handle errors
                        print("TickerService 💥 failed to parse Ticker")
                        onCompletion(.failed(.parsing))
                    }
                    
                case .failed(_):
                    
                    // TODO: handle errors
                    print("TickerService response error")
                    onCompletion(.failed(.unknown))
                }
            }
        }
        catch {
            
            // TODO: handle errors
            print("TickerService - failed to request ticker")
            onCompletion(.failed(.unknown))
        }
    }
    
    func parse(_ json: JSON, for market: Market) throws -> Ticker {
        
        guard let result: JSON = try json.get("result") else { throw Abort.badRequest }
        
        guard let price: Double = try result.get("Last") else { throw Abort.badRequest }
        
        return Ticker(market: market, lastPrice: price)
    }
}

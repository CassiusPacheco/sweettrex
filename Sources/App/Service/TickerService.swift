//
//  TickerService.swift
//  sweettrex
//
//  Created by Cassius Pacheco on 24/9/17.
//
//

import Foundation

protocol TickerServiceProtocol {
    
    func tick(_ market: Market) throws -> Result<Ticker>
}

struct TickerService: TickerServiceProtocol {
    
    private let service: HttpServiceProtocol
    
    init() {
        
        self.init(httpService: HttpService())
    }
    
    init(httpService: HttpServiceProtocol) {
        
        self.service = httpService
    }
    
    func tick(_ market: Market) throws -> Result<Ticker> {
        
        var result: Result<Ticker> = .failed(.unknown)
        
        do {
            
            print("\nTick \(market.name)...")
            
            let requestResult = try service.request(.ticker(market), httpMethod: .GET, bodyData: nil)
            
            switch requestResult {
                
            case .successful(let json):
                
                do {
                    
                    let tick = try self.parse(json, for: market)
                    
                    result = .successful(tick)
                }
                catch {
                    
                    // TODO: handle errors
                    print("TickerService 💥 failed to parse Ticker")
                    result = .failed(.parsing)
                }
                
            case .failed(_):
                
                // TODO: handle errors
                print("TickerService response error")
                result = .failed(.unknown)
            }
        }
        catch {
            
            // TODO: handle errors
            print("TickerService - failed to request ticker")
            result = .failed(.unknown)
        }
        
        return result
    }
    
    func parse(_ json: JSON, for market: Market) throws -> Ticker {
        
        guard let result: JSON = try json.get("result") else { throw Abort.badRequest }
        
        guard let price: Double = try result.get("Last") else { throw Abort.badRequest }
        
        return Ticker(market: market, lastPrice: price)
    }
}

//
//  ExternalUrl.swift
//  sweettrex
//
//  Created by Cassius Pacheco on 23/9/17.
//
//

import Foundation

enum ExternalUrl {
    
    case market
    case ticker(Market)
    
    private static let bittrexBaseUrl = "https://bittrex.com/api/v1.1/public"
    
    var url: URL {
        
        switch self {
            
        case .market:
            
            return URL(string: ExternalUrl.bittrexBaseUrl + "/getmarkets")!
            
        case .ticker(let market):
            
            return URL(string: ExternalUrl.bittrexBaseUrl + "/getticker?market=" + market.name)!
        }
    }
}

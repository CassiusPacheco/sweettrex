//
//  HttpService.swift
//  sweettrex
//
//  Created by Cassius Pacheco on 23/9/17.
//
//

import Foundation
import Vapor

enum HttpMethod: String {
    
    case GET = "GET"
    case DELETE = "DELETE"
    case POST = "POST"
    case PUT = "PUT"
}

enum HttpError {
    
    case json
    case parsing
    case unknown
}

enum Result<T> {
    
    case failed(HttpError)
    case successful(T)
}

protocol HttpServiceProtocol {
    
    func request(_ externalUrl: ExternalUrl, httpMethod: HttpMethod, bodyData: JSON?) throws -> Result<JSON>
}

struct HttpService: HttpServiceProtocol {
    
    static let sharedURLSession = URLSession(configuration: .default)
    
    private let urlSession: URLSessionProtocol
    
    init() {
        
        self.init(urlSession: HttpService.sharedURLSession)
    }
    
    init(urlSession: URLSessionProtocol) {
        
        self.urlSession = urlSession
    }
    
    func request(_ externalUrl: ExternalUrl, httpMethod: HttpMethod, bodyData: JSON?) throws -> Result<JSON> {
        
        var request = URLRequest(url: externalUrl.url)
        request.httpMethod = httpMethod.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let bodyData = bodyData, httpMethod == .POST || httpMethod == .PUT {
            
            do {
                
                let json = try Data(bytes: bodyData.serialize())
                
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                
                request.httpBody = json
            }
            catch {
                
                throw Abort.badRequest
            }
        }
        
        let response = try urlSession.data(with: request)
        
        if urlSession !== HttpService.sharedURLSession {
            
            urlSession.finishTasksAndInvalidate()
        }
        
        var result: Result<JSON> = .failed(.unknown)
        
        do {
            
            if response.data.count > 0 {
                
                let json = try JSON(bytes: response.data)
                
                result = .successful(json)
            }
        }
        catch {
            
            result = .failed(.json)
        }
        
        return result
    }
}

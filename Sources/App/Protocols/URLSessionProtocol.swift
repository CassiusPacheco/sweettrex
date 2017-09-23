//
//  URLSessionProtocol.swift
//  sweettrex
//
//  Created by Cassius Pacheco on 23/9/17.
//
//

import Foundation

protocol URLSessionDataTaskProtocol {
    
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }

protocol URLSessionProtocol: class {
    
    func finishTasksAndInvalidate()
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        
        // The double casting is necessary because both methods have the same name and the compiler gets lost
        return ((dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol)
    }
}

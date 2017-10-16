//
//  URLSessionProtocol.swift
//  sweettrex
//
//  Created by Cassius Pacheco on 23/9/17.
//
//

import Foundation

protocol URLSessionProtocol: class {
    
    func finishTasksAndInvalidate()
    
    func data(with request: URLRequest) throws -> (data: Data, response: HTTPURLResponse)
}

extension URLSession: URLSessionProtocol { }

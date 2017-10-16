//
//  URLSession.swift
//  App
//
//  Created by Cassius Pacheco on 16/10/17.
//

import Foundation

extension URLSession {
    
    func data(with request: URLRequest) throws -> (data: Data, response: HTTPURLResponse) {
        
        var error: Error?
        var result: (Data, HTTPURLResponse)?
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = self.dataTask(with: request, completionHandler: { data, response, _error in
            
            if let data = data, let response = response as? HTTPURLResponse {
                
                result = (data: data, response: response)
            }
            else {
                
                error = _error
            }
            
            semaphore.signal()
        })
        
        task.resume()
        
        semaphore.wait()
        
        if let error = error {
            
            throw error
        }
        else if let result = result {
            
            return result
        }
        else {
            
            fatalError("There's been a major issue in the URLSession extension")
        }
    }
}

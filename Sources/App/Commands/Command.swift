//
//  Command.swift
//  sweettrex
//
//  Created by Cassius Pacheco on 23/9/17.
//
//

import Vapor
import HTTP

// Courtesy of Soroush http://khanlou.com/2017/06/server-side-commands/

protocol SideEffect {
    
    func perform() throws
}

// MARK: - Base Command Protocol

protocol Command {
    
    init(request: Request) throws
    
    func validate() throws
    
    var sideEffects: [SideEffect] { get }
}

extension Command {
    
    var sideEffects: [SideEffect] {
        
        return []
    }
    
    func validate() throws { }
}

// MARK: - ObjectCommand Protocol

protocol ObjectCommand: Command {
    
    associatedtype CommandType
    
    func execute() throws -> CommandType
    
    func makeResult() throws -> CommandType
}

extension ObjectCommand {
    
    func makeResult() throws -> CommandType {
        
        try validate()
        
        let result = try execute()
        
        try sideEffects.forEach({ try $0.perform() })
        
        return result
    }
}

// MARK: - JSONCommand Protocol

protocol JSONCommand: Command, ResponseRepresentable {
    
    var status: Status { get }
    
    func execute() throws -> JSON
}

extension JSONCommand {
    
    func makeResponse() throws -> Response {
        
        let response = Response(status: self.status)
        
        try validate()
        
        response.json = try execute()
        
        try sideEffects.forEach({ try $0.perform() })
        
        return response
    }
}

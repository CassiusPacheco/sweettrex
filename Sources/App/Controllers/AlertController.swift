//
//  AlertController.swift
//  sweettrex
//
//  Created by Cassius Pacheco on 23/9/17.
//
//

import Vapor
import HTTP

final class AlertController {
    
    func create(_ request: Request) throws -> ResponseRepresentable {
        
        guard let contentType = request.headers["Content-Type"], contentType.contains("application/json") else { throw Abort.badRequest }
        
        guard let json = request.json else { throw Abort.badRequest }
        
        let alert = try Alert(json: json)
        
        try alert.save()
        
        return Response(status: .created)
    }
    
    func list(_ request: Request) throws -> ResponseRepresentable {
        
        guard let email = request.query?["email"]?.string else { throw Abort.badRequest }
        
        let alert = try Alert.findAll(byEmail: email)
        
        return try alert.makeJSON()
    }
}

extension AlertController: EmptyInitializable { }

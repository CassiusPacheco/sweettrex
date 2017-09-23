//
//  NotificationRequestController.swift
//  sweettrex
//
//  Created by Cassius Pacheco on 23/9/17.
//
//

import Vapor
import HTTP

final class NotificationRequestController {
    
    func create(_ request: Request) throws -> ResponseRepresentable {
        
        guard let contentType = request.headers["Content-Type"], contentType.contains("application/json") else { throw Abort.badRequest }
        
        guard let json = request.json else { throw Abort.badRequest }
        
        let notificationRequest = try NotificationRequest(json: json)
        
        try notificationRequest.save()
        
        return Response(status: .created)
    }
    
    func list(_ request: Request) throws -> ResponseRepresentable {
        
        guard let email = request.query?["email"]?.string else { throw Abort.badRequest }
        
        let notificationRequests = try NotificationRequest.findAll(byEmail: email)
        
        return try notificationRequests.makeJSON()
    }
}

extension NotificationRequestController: EmptyInitializable { }

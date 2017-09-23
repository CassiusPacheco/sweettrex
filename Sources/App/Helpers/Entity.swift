import Vapor
import FluentProvider

extension Entity {
    
    static func findOr404(_ id: NodeRepresentable) throws -> Self {
        
        guard let result = try self.find(id) else { throw ModelNotFoundError(type: Self.self) }
        
        return result
    }
}

import Vapor
import HTTP

struct ModelNotFoundError: AbortError {
    
    var status: Status {
        
        return .notFound
    }
    
    var reason: String {
        
        return self.message
    }
    
    private let message: String
    
    public init<T>(type: T) {
        
        self.message = "\(type) could not be found."
    }
}

import Vapor

extension Droplet {
    
    func setupRoutes() throws {

        let api = grouped("api", "v1")
        
        api.get("hello") { request in
            
            var json = JSON()
            try json.set("hello", "world")
            
            return json
        }
        
        let marketController = MarketController()
        
        api.get("market") { request in
            
            return try marketController.allMarkets(request)
        }
        
        let alertController = AlertController()
        
        api.post("alert") { request in
            
            return try alertController.create(request)
        }
        
        api.get("alert") { request in
            
            return try alertController.list(request)
        }
    }
}

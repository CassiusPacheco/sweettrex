@_exported import Vapor
import Jobs

extension Droplet {
    
    public func setup() throws {
        
        try setupRoutes()
        // Do any additional droplet setup
        
        setupJobs()
    }
    
    private func setupJobs() {
        
        Jobs.add(interval: .days(1)) {
            
            let job = MarketJob()
            job.fetchAndSaveMarkets()
        }
        
        Jobs.add(interval: .seconds(60)) {
            
            let job = try NotificationRequestJob(droplet: self)
            job.checkNotification()
        }
    }
}

@_exported import Vapor
import Dispatch

private let marketJob = DispatchSource.makeTimerSource()
private let notificationJob = DispatchSource.makeTimerSource()

extension Droplet {
    
    public func setup() throws {
        
        try setupRoutes()
        // Do any additional droplet setup
        
        setupJobs()
    }
    
    private func setupJobs() {
        
        // MARK: - Market
        
        marketJob.scheduleRepeating(deadline: .now(), interval: .seconds(86400))
        
        marketJob.setEventHandler(handler: {
            
            let job = MarketJob()
            job.fetchAndSaveMarkets()
        })
        
        marketJob.resume()
        
        // MARK: - Notification
        
        notificationJob.scheduleRepeating(deadline: .now(), interval: .seconds(60))
        
        notificationJob.setEventHandler(handler: {
            
            guard let job = try? NotificationRequestJob(droplet: self) else {
            
                return print("Notification job hasn't started due to an error")
            }
            
            job.checkNotification()
        })
        
        notificationJob.resume()
    }
}

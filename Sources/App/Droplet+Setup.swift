@_exported import Vapor
import Dispatch

private let marketJob = DispatchSource.makeTimerSource()
private let alertJob = DispatchSource.makeTimerSource()

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
        
        // MARK: - Alert
        
        alertJob.scheduleRepeating(deadline: .now(), interval: .seconds(60))
        
        alertJob.setEventHandler(handler: {
            
            guard let job = try? AlertJob(droplet: self) else {
            
                return print("Alert job hasn't started due to an error")
            }
            
            job.checkAlert()
        })
        
        alertJob.resume()
    }
}

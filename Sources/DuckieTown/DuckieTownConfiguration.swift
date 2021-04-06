//
//  DuckieTownConfiguration.swift
//  
//
//  Created by Timor Morrien on 02.04.21.
//

import Apodini
import Logging


public final class DuckieTownConfiguration: Configuration {
    let logLevel: Logger.Level
    

    public init(logLevel: Logger.Level = .error) {
        self.logLevel = logLevel
    }
    
    
    public func configure(_ app: Application) {
        var logger = Logger(label: "duckie-town")
        logger.logLevel = logLevel
        
        app.duckiebotManager = DuckiebotManager()
        app.duckiebotManager.save()
        //app.duckiebotManager.addDuckiebot(DuckieBot(id: "donald", intersectionId: 0, atDirection: .north))
        app.intersectionManager = IntersectionManager()
        app.intersectionManager.save()
        print(app.intersectionManager.intersections)
    }
}

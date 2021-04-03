//
//  DuckiebotHandler.swift
//  
//
//  Created by Timor Morrien on 01.04.21.
//

import Foundation
import Apodini
import ApodiniREST

struct DuckiebotGetPositionHandler: Handler {
    @Environment(\.duckiebotManager) var duckiebotManager: DuckiebotManager
    
    @Parameter(.http(.path)) var botId: String

    func handle() throws -> PositionMediator {
        guard let duckiebot = duckiebotManager.getDuckiebot(id: botId) else {
            throw ApodiniError(type: .notFound, reason: "Invalid ID", description: "There is no DuckieBot with the given ID in the DuckieTown")
        }
        
        return PositionMediator(intersectionId: duckiebot.intersectionId, atDirection: duckiebot.atDirection)
    }
}


struct DuckiebotSetPositionHandler: Handler {
    @Environment(\.duckiebotManager) var duckiebotManager: DuckiebotManager
    @Environment(\.intersectionManager) var intersectionManager: IntersectionManager
    @Parameter(.http(.path)) var botId: String
    @Parameter(.http(.body)) var position: PositionMediator

    func handle() throws -> PositionMediator {
        guard var duckiebot = duckiebotManager.getDuckiebot(id: botId) else {
            throw ApodiniError(type: .notFound, reason: "Invalid ID", description: "There is no DuckieBot with the given ID in the DuckieTown")
        }
        
        guard let intersection = intersectionManager.getIntersection(by: position.intersectionId) else {
            throw ApodiniError(type: .notFound, reason: "Invalid ID", description: "There is no Intersection with the given ID in the DuckieTown")
        }
        
        guard let _ = position.atDirection.getRoad(intersection: intersection) else {
            throw ApodiniError(type: .notFound, reason: "Invalid Direction", description: "The intersection \(intersection.id) does not have a road in the \(position.atDirection) direction")
        }
        
        duckiebot.intersectionId = position.intersectionId
        duckiebot.atDirection = position.atDirection
        duckiebotManager.save(duckiebot)
        
        return position
    }
}


struct PositionMediator: Content, Decodable {
    var intersectionId: Int64
    var atDirection: IntersectionDirection
}

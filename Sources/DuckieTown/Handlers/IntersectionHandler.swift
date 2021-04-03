//
//  IntersectionHandler.swift
//  
//
//  Created by Timor Morrien on 03.04.21.
//

import Apodini

struct GetIntersectionHandler: Handler {
    @Environment(\.intersectionManager) var intersectionManager: IntersectionManager
    @Parameter(.http(.path)) var intersectionId: Int64

    func handle() throws -> Intersection {
        guard var intersection = intersectionManager.getIntersection(by: intersectionId) else {
            throw ApodiniError(type: .notFound, reason: "Invalid ID", description: "There is no intersection with the given ID in the DuckieTown")
        }
        
        return intersection
    }
}

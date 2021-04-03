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
        guard let intersection = intersectionManager.getIntersection(by: intersectionId) else {
            throw ApodiniError(type: .notFound, reason: "Invalid ID", description: "There is no intersection with the given ID in the DuckieTown")
        }
        
        return intersection
    }
}

struct GetIntersectionsHandler: Handler {
    @Environment(\.intersectionManager) var intersectionManager: IntersectionManager

    func handle() throws -> [Intersection] {
        return intersectionManager.intersections
    }
}

struct SetIntersectionsHandler: Handler {
    @Environment(\.intersectionManager) var intersectionManager: IntersectionManager
    @Parameter(.http(.body)) var intersections: [Intersection]

    func handle() throws -> [Intersection] {
        intersectionManager.setIntersections(intersections)
        
        return intersections
    }
}

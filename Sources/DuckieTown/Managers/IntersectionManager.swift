//
//  IntersectionManager.swift
//  
//
//  Created by Timor Morrien on 01.04.21.
//

import Foundation

class IntersectionManager {
    var intersections: [Intersection]
    
    init() {
        // The Map
        _ = [
            [1,1,1],
            [1,0,1],
            [1,1,1],
            [1,0,1],
            [1,1,1]
        ]
        
        _ = [
            Intersection(id: 0,
                         north: IntersectionRoad(leadsToIntersection: 1, leadsToDirection: .north, lampId: "0"),
                         east: IntersectionRoad(leadsToIntersection: 1, leadsToDirection: .west, lampId: "1"),
                         south: IntersectionRoad(leadsToIntersection: 1, leadsToDirection: .south, lampId: "2"),
                         west: nil),
            Intersection(id: 1,
                         north: IntersectionRoad(leadsToIntersection: 0, leadsToDirection: .north, lampId: "3"),
                         east: nil,
                         south: IntersectionRoad(leadsToIntersection: 0, leadsToDirection: .south, lampId: "4"),
                         west: IntersectionRoad(leadsToIntersection: 0, leadsToDirection: .east, lampId: "5")),
        ]
        
        intersections = (try? FileIOController.read(fromDocumentNamed: "intersections.json")) ?? []
        
        print(intersections)
    }
    
    func getIntersection(by id: Int) -> Intersection? {
        intersections.first { $0.id == id }
    }
    
    func setIntersections(_ intersections: [Intersection]) {
        self.intersections = intersections
        save()
    }
    
    func save() {
        try? FileIOController.write(intersections, toDocumentNamed: "intersections.json")
    }
}

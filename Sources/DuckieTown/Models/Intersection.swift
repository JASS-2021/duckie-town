//
//  Intersection.swift
//  
//
//  Created by Timor Morrien on 01.04.21.
//

import Foundation

struct Intersection {
    var id: Int64
    var north: IntersectionRoad?
    var east: IntersectionRoad?
    var south: IntersectionRoad?
    var west: IntersectionRoad?
    
    init(id: Int64,
         north: IntersectionRoad? = nil,
         east: IntersectionRoad? = nil,
         south: IntersectionRoad? = nil,
         west: IntersectionRoad? = nil) {
        self.id = id
        self.north = north
        self.east = east
        self.south = south
        self.west = west
    }
}

struct IntersectionRoad {
    var leadsToIntersection: Int64
    var leadsToDirection: IntersectionDirection
    var lampId: String?
}

enum IntersectionDirection: String, Codable {
    case north
    case east
    case south
    case west
    
    func getRoad(intersection: Intersection) -> IntersectionRoad? {
        switch self {
        case .north:
            return intersection.north
        case .east:
            return intersection.east
        case .south:
            return intersection.south
        case .west:
            return intersection.west
        }
    }
    
    func turned(_ direction: TurnDirection) -> IntersectionDirection {
        if direction == .right {
            switch self {
            case .north:
                return .west
            case .east:
                return .north
            case .south:
                return .east
            case .west:
                return .south
            }
        } else {
            switch self {
            case .north:
                return .east
            case .east:
                return .south
            case .south:
                return .west
            case .west:
                return .north
            }
        }
    }
    
    var opposite: IntersectionDirection {
        switch self {
        case .north:
            return .south
        case .east:
            return .west
        case .south:
            return .north
        case .west:
            return .east
        }
    }
}

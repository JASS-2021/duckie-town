//
//  DuckiebotInstructionHandler.swift
//
//
//  Created by Timor Morrien on 01.04.21.
//

import Foundation
import Apodini
import ApodiniREST

struct DuckiebotGetInstructionHandler: Handler {
    @Environment(\.duckiebotManager) var duckiebotManager: DuckiebotManager
    @Environment(\.intersectionManager) var intersectionManager: IntersectionManager
    @Parameter(.http(.path)) var botId: String

    func handle() throws -> Instruction {
        guard var duckiebot = duckiebotManager.getDuckiebot(id: botId) else {
            throw ApodiniError(type: .notFound, reason: "Invalid ID", description: "There is no DuckieBot with the given ID in the DuckieTown")
        }
        let instruction = duckiebotManager.getNextInstruction(for: duckiebot)
        let intersection = intersectionManager.getIntersection(by: duckiebot.intersectionId)
        var goToRoad: IntersectionRoad?
        
        switch instruction {
        case .wait(_):
            goToRoad = nil
        case .turn(let direction):
            goToRoad = duckiebot.atDirection.turned(direction).getRoad(intersection: intersection!)
        case .forward:
            goToRoad = duckiebot.atDirection.opposite.getRoad(intersection: intersection!)
        case .turnaround:
            goToRoad = duckiebot.atDirection.getRoad(intersection: intersection!)
        }
        
        if let goToRoad = goToRoad {
            duckiebot.intersectionId = goToRoad.leadsToIntersection
            duckiebot.atDirection = goToRoad.leadsToDirection
            duckiebotManager.save(duckiebot)
            return instruction
        } else {
            print("Invalid instruction")
            return Instruction.wait(time: 5)
        }
        
    }
}


struct DuckiebotAddInstructionHandler: Handler {
    @Environment(\.duckiebotManager) var duckiebotManager: DuckiebotManager
    @Environment(\.intersectionManager) var intersectionManager: IntersectionManager
    @Parameter(.http(.path)) var botId: String
    @Parameter(.http(.body)) var instruction: Instruction

    func handle() throws -> Instruction {
        guard let duckiebot = duckiebotManager.getDuckiebot(id: botId) else {
            throw ApodiniError(type: .notFound, reason: "Invalid ID", description: "There is no DuckieBot with the given ID in the DuckieTown")
        }
        
        duckiebotManager.addInstruction(instruction, to: duckiebot)
        return instruction
    }
}


enum Instruction: Content, Decodable {
    init(from decoder: Decoder) throws {
        var rawInstruction = try decoder.singleValueContainer().decode(String.self)
        if rawInstruction == "turn left" {
            self = .turn(direction: .left)
        } else if rawInstruction == "turn right" {
            self = .turn(direction: .right)
        } else if rawInstruction == "forward" {
            self = .forward
        } else if rawInstruction == "turnaround" {
            self = .turnaround
        } else if rawInstruction.hasPrefix("wait ") {
            self = .wait(time: Int(rawInstruction.split(separator: " ")[1]) ?? 1)
        } else {
            throw ApodiniError(type: .badInput, reason: "Invalid Instruction", description: "The given instruction is not valid")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.toString())
    }
    
    case wait(time: Int)
    case turn(direction: TurnDirection)
    case forward
    case turnaround
    
    func toString() -> String {
        switch self {
        case .wait(let time):
            return "wait \(time)"
        case .turn(let direction):
            return "turn \(direction)"
        case .forward:
            return "forward"
        case .turnaround:
            return "turnaround"
        }
    }
}


enum TurnDirection: String {
    case left
    case right
}

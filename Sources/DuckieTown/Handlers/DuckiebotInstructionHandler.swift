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

    func handle() throws -> String {
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
            return instruction.toString()
        } else {
            print("Invalid instruction")
            return Instruction.wait(time: 5).toString()
        }
        
    }
}


struct DuckiebotAddInstructionHandler: Handler {
    @Environment(\.duckiebotManager) var duckiebotManager: DuckiebotManager
    @Environment(\.intersectionManager) var intersectionManager: IntersectionManager
    @Parameter(.http(.path)) var botId: String
    @Parameter(.http(.body)) var rawInstruction: String

    func handle() throws -> String {
        guard let duckiebot = duckiebotManager.getDuckiebot(id: botId) else {
            throw ApodiniError(type: .notFound, reason: "Invalid ID", description: "There is no DuckieBot with the given ID in the DuckieTown")
        }
        var instruction: Instruction?
        
        if rawInstruction == "turn left" {
            instruction = .turn(direction: .left)
        } else if rawInstruction == "turn right" {
            instruction = .turn(direction: .right)
        } else if rawInstruction == "forward" {
            instruction = .forward
        } else if rawInstruction == "turnaround" {
            instruction = .turnaround
        } else if rawInstruction.hasPrefix("wait ") {
            instruction = .wait(time: Int(rawInstruction.split(separator: " ")[1]) ?? 1)
        }
        
        if let instruction = instruction {
            duckiebotManager.addInstruction(instruction, to: duckiebot)
            return instruction.toString()
        } else {
            throw ApodiniError(type: .badInput, reason: "Invalid Instruction", description: "The given instruction is not valid")
        }
    }
}


enum Instruction {
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

//
//  DuckiebotInstructionHandler.swift
//
//
//  Created by Timor Morrien on 01.04.21.
//

import Foundation
import Apodini
import ApodiniREST

struct DuckiebotInstructionHandler: Handler {
    @Parameter(.http(.path)) var botId: String

    func handle() -> String {
        // TODO
        Instruction.forward.toString()
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

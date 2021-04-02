//
//  DuckiebotManager.swift
//  
//
//  Created by Timor Morrien on 01.04.21.
//

import Foundation

class DuckiebotManager {
    private(set) var duckiebots: [DuckieBot]
    var instructionMap: [String: [Instruction]]
    
    init() {
        self.duckiebots = []
        self.instructionMap = [:]
    }
    
    func addDuckiebot(_ duckiebot: DuckieBot) {
        duckiebots.append(duckiebot)
        instructionMap[duckiebot.id] = []
    }
    
    func getDuckiebot(id: String) -> DuckieBot? {
        duckiebots.first { $0.id == id }
    }
    
    func save(_ duckiebot: DuckieBot) {
        if let index = duckiebots.firstIndex(where: { $0.id == duckiebot.id }) {
            duckiebots[index] = duckiebot
        } else {
            duckiebots.append(duckiebot)
        }
    }
    
    func addInstruction(_ instruction: Instruction, to duckiebot: DuckieBot) {
        instructionMap[duckiebot.id]?.append(instruction)
    }
    
    func getNextInstruction(for duckiebot: DuckieBot) -> Instruction {
        if var queue = instructionMap[duckiebot.id] {
            if !queue.isEmpty {
                let instruction = queue.first
                queue.removeFirst()
                instructionMap[duckiebot.id] = queue
                return instruction ?? .wait(time: 5)
            }
        }
        
        return .wait(time: 5)
    }
}

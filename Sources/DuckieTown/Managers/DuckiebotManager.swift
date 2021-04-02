//
//  DuckiebotManager.swift
//  
//
//  Created by Timor Morrien on 01.04.21.
//

import Foundation

class DuckiebotManager {
    private(set) var duckiebots: [DuckieBot]
    var instructionMap: [Int64: [Instruction]]
    
    init() {
        self.duckiebots = []
        self.instructionMap = [:]
    }
    
    func addDuckiebot(_ duckiebot: DuckieBot) {
        duckiebots.append(duckiebot)
        instructionMap[duckiebot.id] = []
    }
    
    func addInstruction(_ instruction: Instruction, to duckiebot: DuckieBot) {
        instructionMap[duckiebot.id]?.append(instruction)
    }
    
    func getNextInstruction(for duckiebot: DuckieBot) {
        instructionMap[duckiebot.id]?.first ?? .wait(time: 5)
        instructionMap[duckiebot.id]?.removeFirst()
    }
}

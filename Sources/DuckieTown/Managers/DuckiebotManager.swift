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
        self.duckiebots = (try? FileIOController.read(fromDocumentNamed: "duckiebots.json")) ?? []
        self.instructionMap = (try? FileIOController.read(fromDocumentNamed: "instructionMap.json")) ?? [:]
    }
    
    func save() {
        try? FileIOController.write(duckiebots, toDocumentNamed: "duckiebots.json")
        try? FileIOController.write(instructionMap, toDocumentNamed: "instructionMap.json")
    }
    
    func addDuckiebot(_ duckiebot: DuckieBot) {
        duckiebots.append(duckiebot)
        instructionMap[duckiebot.id] = []
        save()
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
        save()
    }
    
    func addInstruction(_ instruction: Instruction, to duckiebot: DuckieBot) {
        instructionMap[duckiebot.id]?.append(instruction)
        save()
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
        save()
        
        return .wait(time: 5)
    }
}

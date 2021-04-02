//
//  DuckiebotHandler.swift
//  
//
//  Created by Timor Morrien on 01.04.21.
//

import Foundation
import Apodini
import ApodiniREST

struct DuckiebotHandler: Handler {
    @Environment(\.duckiebotManager) var duckiebotManager: DuckiebotManager
    
    @Parameter(.http(.path)) var botId: String

    func handle() -> String {
        ""
    }
}

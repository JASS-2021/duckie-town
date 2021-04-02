//
//  DuckieBot.swift
//  
//
//  Created by Timor Morrien on 01.04.21.
//

import Apodini

struct DuckieBot: Codable, Identifiable {
    var id: String
    var intersectionId: Int64
    var atDirection: IntersectionDirection
}

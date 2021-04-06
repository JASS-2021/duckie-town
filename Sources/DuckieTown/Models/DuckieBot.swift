//
//  DuckieBot.swift
//  
//
//  Created by Timor Morrien on 01.04.21.
//

import Apodini

struct DuckieBot: Content, Decodable, Identifiable {
    var id: String
    var intersectionId: Int
    var atDirection: IntersectionDirection
}

//
//  FileIOController.swift
//  
//
//  Created by Timor Morrien on 03.04.21.
//

import Foundation

enum FileIOController {
    static func write<T: Encodable> (
        _ value: T,
        toDocumentNamed documentName: String,
        encodedUsing encoder: JSONEncoder = .init()
    ) throws {
        let folderURL = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("DuckieWeb")
        
        try FileManager.default.createDirectory(
            at: folderURL,
            withIntermediateDirectories: true,
            attributes: nil
        )

        let fileURL = folderURL.appendingPathComponent(documentName)
        let data = try encoder.encode(value)
        try data.write(to: fileURL)
    }
    
    static func read<T: Decodable> (
        fromDocumentNamed documentName: String,
        decoder: JSONDecoder = .init()
    ) throws -> T {
        let folderURL = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ).appendingPathComponent("DuckieWeb")

        let fileURL = folderURL.appendingPathComponent(documentName)
        let data = try Data(contentsOf: fileURL)
        return try decoder.decode(T.self, from: data)
    }
}

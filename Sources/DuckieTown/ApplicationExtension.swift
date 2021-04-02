//
//  ApplicaationExtension.swift
//  
//
//  Created by Timor Morrien on 01.04.21.
//

import Apodini

extension Application {
    struct DuckiebotManagerKey: StorageKey {
        typealias Value = DuckiebotManager
    }

    /// Holds the `DuckiebotManager` of the web service.
    var duckiebotManager: DuckiebotManager {
        get {
            guard let duckiebotManager = self.storage[DuckiebotManagerKey.self] else {
                fatalError("DuckiebotManager not initialized")
            }
            
            return duckiebotManager
        }
        set {
            self.storage[DuckiebotManagerKey.self] = newValue
        }
    }
    
    struct IntersectionManagerKey: StorageKey {
        typealias Value = IntersectionManager
    }
    
    /// Holds the `IntersectionManager` of the web service.
    var intersectionManager: IntersectionManager {
        get {
            guard let intersectionManager = self.storage[IntersectionManagerKey.self] else {
                fatalError("IntersectionManager not initialized")
            }
            
            return intersectionManager
        }
        set {
            self.storage[IntersectionManagerKey.self] = newValue
        }
    }
}

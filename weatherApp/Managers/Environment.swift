//
//  Environment.swift
//  weatherApp
//
//  Created by Андрій on 17.10.2024.
//

import Foundation

struct Env {
    enum Keys {
        static let key = "KEY"
    }
    
    static let key: String? = {
        guard let baseURLProperty = Bundle.main.object(
            forInfoDictionaryKey: Keys.key
        ) as? String else {
            return nil
        }
        return baseURLProperty
    }()
}

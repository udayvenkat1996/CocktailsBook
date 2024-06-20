//
//  UserDefaultsExtension.swift
//  CocktailBook
//
//  Created by Uday Venkat on 20/06/24.
//

import Foundation

extension UserDefaults {
    func setObject<Object: Codable>(_ object: Object, forKey key: String) {
        if let data = try? JSONEncoder().encode(object) {
            set(data, forKey: key)
        }
    }

    func getObject<Object: Codable>(_ objectType: Object.Type, forKey key: String) -> Object? {
        if let data = data(forKey: key), let object = try? JSONDecoder().decode(objectType, from: data) {
            return object
        }
        return nil
    }
}

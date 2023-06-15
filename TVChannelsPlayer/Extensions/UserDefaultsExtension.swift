//
//  UserDefaultsExtension.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 15.06.2023.
//

import Foundation

@propertyWrapper
struct ThreadSafeNonNilUserDefaultsValue<Value: Codable> {
    let key: String
    let storage = UserDefaults.standard
    let defaultValue: Value
    private let mutexQueue = DispatchQueue(label: "com.TVChannelsPlayer.mutexQueue", attributes: .concurrent)
    
    var wrappedValue: Value {
        get { mutexQueue.sync { decodedValue } }
        set { mutexQueue.sync(flags: .barrier) { encodeValue(newValue) } }
    }
    
    private func encodeValue(_ value: Value) {
        if let encoded = try? JSONEncoder().encode(value) {
            storage.set(encoded, forKey: key)
        }
    }
    
    private var decodedValue: Value {
        if let data = storage.object(forKey: key) as? Data,
           let value = try? JSONDecoder().decode(Value.self, from: data) {
            return value
        }
        return defaultValue
    }
}

extension UserDefaults {
    enum Keys: String {
        case favouriteChannels = "favouriteChannels"
    }
}

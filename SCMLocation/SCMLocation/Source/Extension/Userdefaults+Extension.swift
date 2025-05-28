//
//  Userdefaults+Extension.swift
//  SCMLocation
//
//  Created by Lee Wonsun on 5/19/25.
//

import Foundation

public extension UserDefaults {
    
    func saveStructArray<T: Codable>(_ value: T, for key: String) {
        
        var values = self.fetchStruct([T].self, for: key)
        values?.append(value)
        
        if let data = try? Coder.encoder.encode(values) {
            self.set(data, forKey: key)
        }
    }
    
    func deleteStructArray<T: Codable & Equatable>(_ value: T, for key: String) {
        
        let values = self.fetchStruct([T].self, for: key)
        guard let values, !values.isEmpty else { return }
        
        let index = values.firstIndex { $0 == value }
        guard let index else { return }
        
        var arrays = values
        arrays.remove(at: index)
        
        if let data = try? Coder.encoder.encode(arrays) {
            self.set(data, forKey: key)
        }
    }
    
    func fetchStruct<T: Decodable>(_ type: T.Type, for key: String) -> T? {
        
        guard let data = self.data(forKey: key) else { return nil }
        guard let decoded = try? Coder.decoder.decode(T.self, from: data) else { return nil}
        
        return decoded
    }
}

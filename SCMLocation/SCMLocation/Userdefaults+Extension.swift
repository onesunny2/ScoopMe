//
//  Userdefaults+Extension.swift
//  SCMLocation
//
//  Created by Lee Wonsun on 5/19/25.
//

import Foundation

extension UserDefaults {
    
    func saveStructArray<T: Encodable>(_ value: T, for key: String) {
        if let data = try? Coder.encoder.encode(value) {
            self.set(data, forKey: key)
        }
    }
    
    func fetchStruct<T: Decodable>(_ type: T.Type, for key: String) -> T? {
        
        guard let data = self.data(forKey: key) else { return nil }
        guard let decoded = try? Coder.decoder.decode(T.self, from: data) else { return nil}
        
        return decoded
    }
}

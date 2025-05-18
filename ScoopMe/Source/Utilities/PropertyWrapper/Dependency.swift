//
//  Dependency.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/18/25.
//

import Foundation

@propertyWrapper
struct Dependency<T: AnyObject> {
    private let value: T
    
    init() {
        self.value = DIContainer.shared.resolve(T.self)
    }
    
    var wrappedValue: T {
        return value
    }
}

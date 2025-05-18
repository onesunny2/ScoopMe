//
//  DIContainer.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/18/25.
//

import Foundation
import SCMLogger
import SCMLogin

final class DIContainer {
    static var shared = DIContainer()
    
    private var services: [ObjectIdentifier: () -> AnyObject]
    
    private init() {
        self.services = [:]
        
        register(LoginManager.self) { LoginManager() }
        register(LoginTokenManager.self) { LoginTokenManager() }
    }
    
    private func register<T: AnyObject>(
        _ type: T.Type,
        factory: @escaping () -> T
    ) {
        let key = ObjectIdentifier(type)
        
        if services[key] != nil {
            Log.error("DIContainer: \(type) is already registered. Overwriting...")
        }
        
        services[key] = factory
    }
    
    func resolve<T: AnyObject>(_ type: T.Type) -> T {
        let key = ObjectIdentifier(type)
        guard let factory = services[key] as? () -> T else {
            fatalError("DIContainer: \(type) not registered")
            Log.error("DIContainer: \(type) not registered")
        }
        
        return factory()
    }
}

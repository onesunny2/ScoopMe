//
//  AppRoute.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/11/25.
//

import Foundation
import SCMLogin

enum AppRoute: Hashable {
    case login
    case home(tab: Int)
    case order(tab: Int)
    case community(tab: Int)
    case profile(tab: Int)
    case chatting(tab: Int)
}

enum LoginRoute: Hashable {
    case emailLogin(manager: LoginManager)
    case signup
    
    static func == (lhs: LoginRoute, rhs: LoginRoute) -> Bool {
        switch (lhs, rhs) {
        case (.emailLogin(let lhsManager), .emailLogin(let rhsManager)):
            return ObjectIdentifier(lhsManager) == ObjectIdentifier(rhsManager)
        case (.signup, .signup):
            return true
        default: return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .emailLogin(let manager):
            hasher.combine(ObjectIdentifier(manager))
        case .signup:
            hasher.combine("signup")
        }
    }
}

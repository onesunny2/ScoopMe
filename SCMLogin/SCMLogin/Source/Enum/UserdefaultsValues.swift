//
//  UserdefaultsValues.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 6/29/25.
//

import Foundation

public enum UserdefaultsValues {
    case savedUserID
    case autoLoginStatus
    
    var key: String {
        switch self {
        case .savedUserID: return "userIDKey"
        case .autoLoginStatus: return "autoLoginStatus"
        }
    }
    
    public var stringValue: String {
        switch self {
        case .savedUserID:
            return UserDefaults.standard.string(forKey: self.key) ?? ""
        default: return ""
        }
    }
    
    public var boolValue: Bool {
        switch self {
        case .autoLoginStatus:
            return UserDefaults.standard.bool(forKey: self.key)
        default: return false
        }
    }
}

//
//  UserdefaultsValues.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 6/29/25.
//

import Foundation

public enum UserdefaultsValues {
    case savedUserID
    
    var key: String {
        switch self {
        case .savedUserID: return "userIDKey"
        }
    }
    
    var stringValue: String {
        switch self {
        case .savedUserID:
            return UserDefaults.standard.string(forKey: self.key) ?? ""
        }
    }
}

//
//  Keychain.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 5/15/25.
//

import Foundation

public enum Keychain: String {
    case deviceToken
    case accessToken
    case refreshToken
    
    var key: String {
        return "com.Tynee.ScoopMe." + self.rawValue
    }
}

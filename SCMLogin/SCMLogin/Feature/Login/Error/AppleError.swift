//
//  AppleError.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 7/10/25.
//

import Foundation

public enum AppleError: LocalizedError {
    case invalidCredentail
    
    public var errorDescription: String? {
        switch self {
        case .invalidCredentail:
            return "유효하지 않은 애플 인증 정보입니다."
        }
    }
}

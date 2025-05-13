//
//  AppleError.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/13/25.
//

import Foundation

enum AppleError: LocalizedError {
    case invalidCredentail
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentail:
            return "유효하지 않은 애플 인증 정보입니다."
        }
    }
}

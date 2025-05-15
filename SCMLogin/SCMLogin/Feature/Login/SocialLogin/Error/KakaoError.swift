//
//  KakaoError.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 5/13/25.
//

import Foundation

public enum KakaoError: LocalizedError {
    case noAccessToken
    case loginFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .noAccessToken:
            return "❎ Access Token not found"
        case .loginFailed(let message):
            return "❎ Kakao Login failed: \(message)"
        }
    }
}

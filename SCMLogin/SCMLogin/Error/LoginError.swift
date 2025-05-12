//
//  LoginError.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 5/12/25.
//

import Foundation

public enum LoginError: LocalizedError {
    case noAccessToken
    case kakaoLoginFailed(String)
    case appleLoginFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .noAccessToken:
            return "❎ Access Token not found"
        case .kakaoLoginFailed(let message):
            return "❎ Kakao Login failed: \(message)"
        case .appleLoginFailed(let message):
            return "❎ Apple Login failed: \(message)"
        }
    }
}

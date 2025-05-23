//
//  LoginURL.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 5/13/25.
//

import Foundation
import SCMNetwork

public enum LoginURL {
    case checkEmail(email: String)
    case join(email: String, pw: String, nick: String, phone: String?, device: String?)
    case emailLogin(email: String, pw: String, device: String?)
    case kakaoLogin(oauth: String, device: String?)
    case appleLogin(id: String, device: String?, nick: String?)
    case refreshToken(access: String, refresh: String)
    case updateDeviceToken(device: String, access: String)
    
    var baseURL: String {
        return Secret.baseURL
    }
    
    var method: HTTPMethods {
        switch self {
        case .refreshToken:
            return .get
        case .updateDeviceToken:
            return .put
        default:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .checkEmail: "/v1/users/validation/email"
        case .join: "/v1/users/join"
        case .emailLogin: "/v1/users/login"
        case .kakaoLogin: "/v1/users/login/kakao"
        case .appleLogin: "/v1/users/login/apple"
        case .refreshToken: "/v1/auth/refresh"
        case .updateDeviceToken: "/v1/users/deviceToken"
        }
    }
    
    var jsonBody: [String: Any?]? {
        switch self {
        case let .checkEmail(email):
            return ["email": email]
        case let .join(email, pw, nick, phone, device):
            return [
                "email": email,
                "password": pw,
                "nick": nick,
                "phoneNum": phone,
                "deviceToken": device
            ]
        case let .emailLogin(email, pw, device):
            return [
                "email": email,
                "password": pw,
                "deviceToken": device
            ]
        case let .kakaoLogin(oauth, device):
            return [
                "oauthToken": oauth,
                "deviceToken": device
            ]
        case let .appleLogin(id, device, nick):
            return [
                "idToken": id,
                "deviceToken": device,
                "nick": nick
            ]
        case let .updateDeviceToken(device, _):
            return ["deviceToken": device]
        default: return nil
        }
    }
    
    var headers: [String: String] {
        switch self {
        case let .refreshToken(access, refresh):
            return [
                "Content-Type": "application/json",
                "SeSACKey": Secret.apiKey,
                "RefreshToken": refresh,
                "Authorization": access
            ]
        case let .updateDeviceToken(_, access):
            return [
                "accept": "application/json",
                "Content-Type": "application/json",
                "SeSACKey": Secret.apiKey,
                "Authorization": access
            ]
        default:
            return [
                "Content-Type": "application/json",
                "SeSACKey": Secret.apiKey
            ]
        }
    }
}


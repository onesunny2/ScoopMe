//
//  LoginType.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/10/25.
//

import SwiftUI

enum LoginType: String, CaseIterable {
    case apple
    case kakao
    case email
    
    var text: String {
        switch self {
        case .apple: "Apple로 로그인"
        case .kakao: "카카오톡으로 로그인"
        case .email: "이메일 로그인・회원가입"
        }
    }
    
    var symbolImage: Image {
        switch self {
        case .apple: return Image(.appleLogo)
        case .kakao: return Image(.messageFill)
        case .email: return Image(.envelopeFill)
        }
    }
    
    var bgColor: Color {
        switch self {
        case .apple: return .scmGray100
        case .kakao: return .scmKakaoBG
        case .email: return .scmGray15
        }
    }
    
    var symbolColor: Color {
        switch self {
        case .apple: return .scmGray0
        case .kakao: return .scmKakaoSymbol
        case .email: return .scmBlackSprout
        }
    }
    
    var labelColor: Color {
        switch self {
        case .apple: return .scmGray0
        case .kakao: return .scmKakaoLabel
        case .email: return .scmGray100
        }
    }
}

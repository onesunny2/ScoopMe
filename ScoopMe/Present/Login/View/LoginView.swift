//
//  LoginView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/10/25.
//

import SwiftUI
import SCMLogin

struct LoginView: View {
    
    @EnvironmentObject private var router: Router
    
    private var horizontalPadding: CGFloat = 40
    
    var body: some View {
        ZStack {
            Color.scmBrightSprout
                .ignoresSafeArea()
            
            vstackContents
        }
    }
    
    private var vstackContents: some View {
        VStack(alignment: .center, spacing: 0) {
            
            Text(StringLiterals.title.text)
                .basicText(.JNLargeTitle1, .scmBlackSprout)
            
            Text(StringLiterals.subTitle.text)
                .basicText(.PTTitie2, .scmBlackSprout)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
            
            Image(.food3D)
                .basicImage(width: 200)
                .padding(.vertical, 44)
            
            loginButtons
        }
    }
    
    private var loginButtons: some View {
        VStack(spacing: 10) {
            ForEach(LoginType.allCases, id: \.rawValue) { type in
                loginButton(type)
            }
        }
    }
    
    private func loginButton(_ type: LoginType) -> some View {
        
        RoundedRectangle(cornerRadius: 5)
            .fill(type.bgColor)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(
                        (type == .email) ? .scmBlackSprout : .clear,
                        lineWidth: 0.5
                    )
            )
            .overlay(alignment: .leading) {
                type.symbolImage
                    .basicImage(width: 18, color: type.symbolColor)
                    .padding(.leading, 20)
            }
            .overlay(alignment: .center) {
                Text(type.text)
                    .basicText(.PTTitle3, type.labelColor)
            }
            .frame(height: 48)
            .padding(.horizontal, horizontalPadding)
            .asButton {
                switch type {
                case .apple:
                    Log.error("error Test")
                case .kakao:
                    Task {
                        try await KakaoLoginManager.shared.kakaoLogin()
                    }
                case .email:
                    router.pushLoginRoute(.emailLogin)
                }
            }
    }
}

private enum StringLiterals {
    case title
    case subTitle
    
    var text: String {
        switch self {
        case .title: "SCOOP ME"
        case .subTitle: "한 번의 스쿱으로\n빠르게 픽업하는 맛있는 시간"
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(Router())
}

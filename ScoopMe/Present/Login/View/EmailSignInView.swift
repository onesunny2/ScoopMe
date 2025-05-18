//
//  EmailSignInView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/10/25.
//

import SwiftUI
import SCMLogger
import SCMLogin

struct EmailSignInView: View {
    
    @EnvironmentObject private var flowSwitcher: SCMSwitcher
    private let router = SCMRouter<LoginPath>.shared
    private let loginManager = DIContainer.shared.loginManager
    private let loginTokenManager = DIContainer.shared.loginTokenManager
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var autoLoginStatus: Bool = false
    
    @State private var showProgressView: Bool = false
    
    var body: some View {
        ZStack {
            Color.scmBrightSprout
                .ignoresSafeArea()
            
            vstackContents
            
            if showProgressView {
                Rectangle()
                    .fill(.scmGray100.opacity(0.3))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .overlay(alignment: .center) {
                        ProgressView()
                            .tint(.scmBlackSprout)
                    }
            }
        }
        .backButton(.scmBlackSprout)
    }
    
    private var vstackContents: some View {
        VStack(alignment: .center, spacing: 0) {
            Text(StringLiterals.title.text)
                .basicText(.JNLargeTitle1, .scmBlackSprout)
            
            Text(StringLiterals.subtitle.text)
                .basicText(.PTBody1, .scmBlackSprout)
                .padding(.top, 16)
            
            VStack(alignment: .leading, spacing: 12) {
                emailField
                passwordField
                
                autoLogin
            } .defaultHorizontalPadding()
            
            bottomLogin
        }
    }
    
    private var emailField: some View {
        LoginTextFieldCell(
            text: $email,
            placeholder: StringLiterals.emailHolder.text
        )
        .padding(.top, 40)
    }
    
    private var passwordField: some View {
        LoginSecureFieldCell(
            text: $password,
            placeholder: StringLiterals.pwHolder.text
        )
    }
    
    private var autoLogin: some View {
        HStack(alignment: .center, spacing: 8) {
            Image(autoLoginStatus ? .checkmarkSquareFill : .square)
                .basicImage(width: 20, color: .scmBlackSprout)
            
            Text(StringLiterals.autoLogin.text)
                .basicText(.PTBody1, .scmGray75)
        }
        .asButton {
            autoLoginStatus.toggle()
            loginTokenManager.setAutoLoginAvailable(autoLoginStatus)
            Log.debug("자동로그인 유무: \(autoLoginStatus)")
        }
    }
    
    @MainActor
    private var bottomLogin: some View {
        VStack(alignment: .trailing, spacing: 12) {
            NextButtonCell(
                title: StringLiterals.loginButton.text,
                buttonColor: .scmBlackSprout
            )
            .asButton {
                Task {
                    await loginManager.postEmailLogin(email, password) {
                        await switchToMainView()
                    }
                }
            }
            
            Text(StringLiterals.signup.text)
                .basicText(.PTBody2, .scmGray75)
                .asButton {
                    router.send(.push(.signUp))
                }
        }
        .defaultHorizontalPadding()
        .padding(.top, 40)
    }
}

extension EmailSignInView {
    private func switchToMainView() async {
        showProgressView = true
        try? await Task.sleep(for: .seconds(2))
        showProgressView = false
        flowSwitcher.switchTo(.main)
    }
}

private enum StringLiterals {
    case title
    case subtitle
    case emailHolder
    case pwHolder
    case autoLogin
    case loginButton
    case signup
    
    var text: String {
        switch self {
        case .title: return "Login"
        case .subtitle: return "스쿱미에 오신 것을 환영합니다 :)"
        case .emailHolder: return "이메일 주소"
        case .pwHolder: return "비밀번호"
        case .autoLogin: return "로그인 상태 유지"
        case .loginButton: return "로그인"
        case .signup: return "이메일로 가입하기 >"
        }
    }
}

#Preview {
    EmailSignInView()
}

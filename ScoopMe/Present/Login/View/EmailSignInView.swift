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
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var autoLoginStatus: Bool = false
    
    private let router = Router<LoginPath>.shared
    let loginManager: LoginManager
    
    var body: some View {
        ZStack {
            Color.scmBrightSprout
                .ignoresSafeArea()
            
            vstackContents
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
            Log.error("Logger로 변경사항 확인 테스트 주우우우우웅")
        }
    }
    
    private var bottomLogin: some View {
        VStack(alignment: .trailing, spacing: 12) {
            NextButtonCell(
                title: StringLiterals.loginButton.text,
                buttonColor: .scmBlackSprout
            )
            .asButton {
                Task {
                    await loginManager.postEmailLogin(email, password)
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
    EmailSignInView(loginManager: LoginManager())
}

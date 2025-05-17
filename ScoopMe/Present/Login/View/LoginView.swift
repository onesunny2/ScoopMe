//
//  LoginView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/10/25.
//

import SwiftUI
import AuthenticationServices
import SCMLogger
import SCMLogin

struct LoginView: View {
    
    @StateObject private var router = SCMRouter<LoginPath>.shared
    @StateObject private var loginManager: LoginManager
    
    private var horizontalPadding: CGFloat = 40
    
    init(loginManager: LoginManager) {
        self._loginManager = StateObject(wrappedValue: loginManager)
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack {
                Color.scmBrightSprout
                    .ignoresSafeArea()
                
                vstackContents
            }
            .showAlert(
                isPresented: $loginManager.loginFalied,
                title: loginManager.alertTitle,
                message: loginManager.alertMessage
            )
            .navigationDestination(for: LoginPath.self) { route in
                switch route {
                case let .emailLogin(manager):
                    EmailSignInView(loginManager: manager)
                case .signUp:
                    SignUpView()
                }
            }
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
                    break
                case .kakao:
                    Task {
                        let data = try await KakaoLoginManager.shared.kakaoLogin()
                        await loginManager.postKakaoLogin(oauth: data)
                    }
                case .email:
                    router.send(.push(.emailLogin(loginManager)))
                }
            }
            .overlay {
                if type == .apple {
                    SignInWithAppleButton(
                        .signIn,
                        onRequest: { request in
                            request.requestedScopes = [.fullName, .email]
                        },
                        onCompletion: { result in
                            getAppleAuth(result)
                        }
                    )
                    .signInWithAppleButtonStyle(.black)
                    .blendMode(.overlay)
                    .padding(.horizontal, horizontalPadding)
                }
            }
    }
    
    /// 애플 로그인 결과 값에 대한 분기처리
    private func getAppleAuth(_ result: Result<ASAuthorization, any Error>) {
        switch result {
        case let .success(authResult):
            Log.debug("애플로그인 성공")
            if let credential = authResult.credential as? ASAuthorizationAppleIDCredential {
                if let token = credential.identityToken, let stringToken = String(data: token, encoding: .utf8) {
                    Log.debug("애플로그인 토큰: \(stringToken)")
                    
                    Task {
                        await loginManager.postAppleLogin(id: stringToken)
                    }
                }
            }
            
        case let .failure(error):
            Log.error("애플로그인 오류: \(AppleError.invalidCredentail.localizedDescription)")
            loginManager.alertMessage = "\(error.localizedDescription)"
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
    LoginView(loginManager: LoginManager())
}

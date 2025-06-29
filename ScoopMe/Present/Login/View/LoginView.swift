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
    
    @EnvironmentObject private var flowSwitcher: SCMSwitcher<MainFlow>
    @StateObject private var router = SCMRouter<LoginPath>.shared
    @StateObject private var loginManager = DIContainer.shared.loginManager
    
    @State private var showProgressView: Bool = false
    private var horizontalPadding: CGFloat = 40
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack {
                Color.scmBrightSprout
                    .ignoresSafeArea()
                
                vstackContents
                progressView
            }
            .showAlert(
                isPresented: $loginManager.loginFalied,
                title: loginManager.alertTitle,
                message: loginManager.alertMessage
            )
            .navigationDestination(for: LoginPath.self) { route in
                switch route {
                case .emailLogin:
                    EmailSignInView()
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
    
    @MainActor
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
                        await loginManager.postKakaoLogin(oauth: data) {
                            // 로그인 성공 시 화면 이동
                            await switchToMainView()
                        }
                    }
                case .email:
                    router.send(.push(.emailLogin))
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
    
    @ViewBuilder
    private var progressView: some View {
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
}

extension LoginView {
    
    /// 애플 로그인 결과 값에 대한 분기처리
    private func getAppleAuth(_ result: Result<ASAuthorization, any Error>) {
        switch result {
        case let .success(authResult):
            Log.debug("애플로그인 성공")
            if let credential = authResult.credential as? ASAuthorizationAppleIDCredential {
                if let token = credential.identityToken, let stringToken = String(data: token, encoding: .utf8) {
                    Log.debug("애플로그인 토큰: \(stringToken)")
                    
                    Task {
                        await loginManager.postAppleLogin(id: stringToken) {
                            await switchToMainView()
                        }
                    }
                }
            }
            
        case let .failure(error):
            Log.error("애플로그인 오류: \(AppleError.invalidCredentail.localizedDescription)")
            loginManager.alertMessage = "\(error.localizedDescription)"
        }
    }
    
    private func switchToMainView() async {
        showProgressView = true
        try? await Task.sleep(for: .seconds(2))
        showProgressView = false
        flowSwitcher.switchTo(.main)
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
}

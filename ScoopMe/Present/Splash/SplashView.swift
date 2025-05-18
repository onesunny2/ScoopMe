//
//  SplashView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/16/25.
//

import SwiftUI
import SCMLogin

struct SplashView: View {
    
    @EnvironmentObject private var flowSwitcher: SCMSwitcher
    private let loginTokenManager = DIContainer.shared.loginTokenManager
    
    @State private var angle: Double = 0
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            Color.scmBrightSprout
                .ignoresSafeArea()
            
            shakeImage
        }
        .task {
            try? await Task.sleep(for: .seconds(3))
            
            await setAutoLogin()
        }
    }
    
    private var shakeImage: some View {
        Image(.splash3D)
            .basicImage(width: 270)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: 0.6)
                        .repeatForever(autoreverses: true)
                ) {
                    scale = 1.1
                }
            }
    }
}

extension SplashView {
    private func setAutoLogin() async {
        if loginTokenManager.autoLoginAvailable {
            do {
                try await loginTokenManager.requestRefreshToken()
                
                if loginTokenManager.isNeedLogin {
                    flowSwitcher.switchTo(.login)
                } else {
                    flowSwitcher.switchTo(.main)
                }
            } catch {
                // 기본적으로는 로그인 화면으로 이동
                flowSwitcher.switchTo(.login)
            }
        } else {
            flowSwitcher.switchTo(.login)
        }
    }
}

#Preview {
    SplashView()
}

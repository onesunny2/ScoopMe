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
    @StateObject private var loginTokenManager: LoginTokenManager
    
    @State private var angle: Double = 0
    @State private var scale: CGFloat = 1.0
    
    init() {
        self._loginTokenManager = StateObject(wrappedValue: LoginTokenManager())
    }
    
    var body: some View {
        ZStack {
            Color.scmBrightSprout
                .ignoresSafeArea()
            
            shakeImage
        }
        .task {
            
            try? await Task.sleep(for: .seconds(3))
            
            let access = loginTokenManager.fetchToken(.accessToken)
            let refresh = loginTokenManager.fetchToken(.refreshToken)
            
            await loginTokenManager.requestRefreshToken(
                access,
                refresh) {
                    if loginTokenManager.isNeedLogin {
                        flowSwitcher.switchTo(.login)
                    } else {
                        flowSwitcher.switchTo(.main)
                    }
                    
                }
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

#Preview {
    SplashView()
}

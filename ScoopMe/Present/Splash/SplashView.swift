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
            
            if loginTokenManager.autoLoginAvailable {
                await loginTokenManager.requestRefreshToken {
                    if loginTokenManager.isNeedLogin {
                        flowSwitcher.switchTo(.login)
                    } else {
                        flowSwitcher.switchTo(.main)
                    }
                }
            } else {
                flowSwitcher.switchTo(.login)
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

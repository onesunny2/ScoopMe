//
//  SplashView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/16/25.
//

import SwiftUI

struct SplashView: View {
    
    @State private var angle: Double = 0
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            Color.scmBrightSprout
                .ignoresSafeArea()
            
            shakeImage
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

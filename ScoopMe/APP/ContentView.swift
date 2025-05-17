//
//  ContentView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/10/25.
//

import SwiftUI
import SCMLogin

struct ContentView: View {
    
    @EnvironmentObject private var flowSwitcher: SCMSwitcher
    
    var body: some View {
        mainFlowView
    }
    
    @ViewBuilder
    private var mainFlowView: some View {
        switch flowSwitcher.currentFlow {
        case .splash:
            SplashView()
        case .login:
            LoginView()
        case .main:
            MainTabView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(SCMSwitcher.shared)
}

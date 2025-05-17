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
    @StateObject private var loginManager = LoginManager()
    
    var body: some View {
        mainFlowView
    }
    
    @ViewBuilder
    private var mainFlowView: some View {
        switch flowSwitcher.currentFlow {
        case .splash:
            SplashView()
        case .login:
            LoginView(loginManager: loginManager)
        case .main:
            MainTabView()
        }
    }
}

#Preview {
    ContentView()
}

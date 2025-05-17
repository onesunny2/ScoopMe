//
//  ContentView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/10/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var router = SCMRouter<MainFlow>.shared
    @State private var currentFlow: MainFlow = .splash
    
    var body: some View {
        mainFlowView
    }
    
    @ViewBuilder
    private var mainFlowView: some View {
        switch currentFlow {
        case .splash:
            SplashView()
        case let .login(manager):
            LoginView(loginManager: manager)
        case .main:
            MainTabView()
        }
    }
}

#Preview {
    ContentView()
}

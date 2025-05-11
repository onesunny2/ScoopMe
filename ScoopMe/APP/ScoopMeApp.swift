//
//  ScoopMeApp.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/10/25.
//

import SwiftUI

@main
struct ScoopMeApp: App {
    
    @StateObject private var router = Router()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.loginPath) {
                LoginView()
                    .navigationDestination(for: LoginRoute.self) { route in
                        switch route {
                        case .emailLogin: EmailSignInView()
                        case .signup: SignUpView()
                        }
                    }
            }
            .environmentObject(router)
        }
    }
}

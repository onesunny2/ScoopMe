//
//  ScoopMeApp.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/10/25.
//

import SwiftUI
import SCMLogin

@main
struct ScoopMeApp: App {
    
    @StateObject private var router = Router()
    
    init() {
        // kakao sdk 초기화
        KakaoLoginConfiguration.iniKakaoSDK(Secret.kakaoKey)
        // alert system color set
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(Color.scmBlackSprout)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.loginPath) {
                LoginView(loginManager: LoginManager())
                    .navigationDestination(for: LoginRoute.self) { route in
                        switch route {
                        case let .emailLogin(manager): EmailSignInView(loginManager: manager)
                        case .signup: SignUpView()
                        }
                    }
                    .onOpenURL { url in
                        _ = KakaoLoginConfiguration.handleKakaoCallback(url)
                    }
            }
            .environmentObject(router)
        }
    }
}

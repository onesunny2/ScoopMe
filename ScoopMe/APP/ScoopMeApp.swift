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
                LoginView()
                    .navigationDestination(for: LoginRoute.self) { route in
                        switch route {
                        case .emailLogin: EmailSignInView()
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

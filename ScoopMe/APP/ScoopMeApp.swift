//
//  ScoopMeApp.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/10/25.
//

import SwiftUI
import SCMLogin
import UserNotifications

@main
struct ScoopMeApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var flowSwitcher = SCMSwitcher.shared
    
    init() {
        // kakao sdk 초기화
        KakaoLoginConfiguration.initKakaoSDK(Secret.kakaoKey)
        // alert system color set
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(Color.scmBlackSprout)
        
        SDWebImageCacheManager.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(flowSwitcher)
                .onOpenURL { url in
                    _ = KakaoLoginConfiguration.handleKakaoCallback(url)
                }
        }
    }
}

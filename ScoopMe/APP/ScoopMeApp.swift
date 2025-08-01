//
//  ScoopMeApp.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/10/25.
//

import SwiftUI
import UserNotifications
import iamport_ios
import SCMLogin

@main
struct ScoopMeApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject private var mainFlowSwitcher = SCMSwitcher<MainFlow>.shared
    @StateObject private var tabFlowSwitcher = SCMSwitcher<TabFlow>.shared
    @StateObject private var chatRoomTracker = ChatRoomTracker.shared
    
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
                .environmentObject(mainFlowSwitcher)
                .environmentObject(tabFlowSwitcher)
                .environmentObject(chatRoomTracker)
                .onOpenURL { url in
                    _ = KakaoLoginConfiguration.handleKakaoCallback(url)
                    Iamport.shared.receivedURL(url)
                }
                .onChange(of: scenePhase) { newPhase in
                    chatRoomTracker.updateAppState(newPhase == .active)
                }
        }
    }
}

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
    @StateObject private var chatRouter = SCMRouter<ChatPath>.shared
    
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
                .environmentObject(chatRouter)
                .environmentObject(chatRoomTracker)
                .onOpenURL { url in
                    _ = KakaoLoginConfiguration.handleKakaoCallback(url)
                    Iamport.shared.receivedURL(url)
                }
                .onChange(of: scenePhase) { newPhase in
                    chatRoomTracker.updateAppState(newPhase == .active)
                }
                .onReceive(
                    NotificationCenter.default.publisher(
                        for: .navigateToChatRoom
                    )
                ) { notification in
                    if let aps = notification.userInfo?["aps"] as? [String: Any], let alert = aps["alert"] as? [String: Any], let roomID = notification.userInfo?["room_id"] as? String {
                        
                        let opponentName = alert["subtitle"] as? String ?? ""
                        
                        navigateToChatRoom(room: roomID, opponent: opponentName)
                    }
                }
        }
    }
    
    private func navigateToChatRoom(room id: String, opponent name: String) {
        // 채팅탭으로 가서, 해당 채팅방으로 보내는 로직
        tabFlowSwitcher.switchTo(.chat)
        chatRouter.send(.push(.chatRoom(roomID: id, opponentName: name)))
    }
}

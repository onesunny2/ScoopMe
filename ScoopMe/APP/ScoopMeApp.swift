//
//  ScoopMeApp.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/10/25.
//

import SwiftUI
import UserNotifications
import iamport_ios
import SCMLogger
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
                        
                        if scenePhase == .active {
                            Log.debug("foreground에서 알림 클릭")
                            navigateToChatRoom(room: roomID, opponent: opponentName)
                        } else {
                            // TODO: 자동로그인 + 토큰세션 만료 여부 확인
                            Log.debug("background에서 알림 클릭")
                            navigateToChatRoom(room: roomID, opponent: opponentName)
                        }
                    }
                }
        }
    }
    
    // background, foreground 상태에 따라 다르게 작동하도록 해야 함
    // foreground: chat 탭으로 화면 switch 해서 채팅방으로 넘어가게 하기
    // background: launch 화면에서 인디케이터 돌리면서 현재 자동로그인 + 토큰 세션 만료되지 않았으면 foreground와 동일하게
        // 만약 자동로그인 아니거나 세션 만료되었으면 로그인 화면으로 돌리기
    private func navigateToChatRoom(room id: String, opponent name: String) {
        // 채팅탭으로 가서, 해당 채팅방으로 보내는 로직
        tabFlowSwitcher.switchTo(.chat)
        chatRouter.send(.push(.chatRoom(roomID: id, opponentName: name)))
    }
}

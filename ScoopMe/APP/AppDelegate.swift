//
//  AppDelegate.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/15/25.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import SCMLogger
import SCMLogin

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    private var chatRoomTracker: ChatRoomTracker {
        return ChatRoomTracker.shared
    }
    
    private let deviceTokenManager = DIContainer.shared.deviceTokenManager
    private let notificationBadgeManager = DIContainer.shared.notificationBadgeManager
    
    private var notificationIDs = Set<String>()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        
        let notifiOption: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: notifiOption) { granted, error in
            if granted {
                Log.debug("알림 권한 허용됨")
            } else {
                Log.debug("알림 권한 거부됨")
            }
        }
        
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // APNs 토큰 수신 성공 시
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // 앱이 백그라운드에 있을 때 알림 처리
    func application(_ application: UIApplication, didreceivedRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let message = userInfo["room_id"] as? String else { return }
        Log.debug("background push 알림 수신: \(message)")
        
        completionHandler(.newData)
    }
    
    // 앱이 포그라운드에 있을 때 알림 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        let notificationID = notification.request.identifier
        let timestamp = Date().timeIntervalSince1970
        
        guard !notificationIDs.contains(notificationID) else {
            completionHandler([])
            return
        }
        
        notificationIDs.insert(notificationID)
        
        Log.debug("foreground push 알림 수신", "timestamp: \(timestamp), notificationID: \(notificationID)", "userInfo: \(userInfo)")

        guard let roomID = userInfo["room_id"] as? String else { return }
        
        if chatRoomTracker.isInChatRoom(room: roomID) {
            completionHandler([])
            return
        }
        
        notificationBadgeManager.addBadgeCount(roomID: roomID)
        completionHandler([.banner, .badge, .list, .sound])
    }
    
    // 알림 탭 했을 때 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        Log.debug("알림 탭", "userInfo: \(userInfo)")
        
        // ✅ 전체 userInfo를 그대로 전달 (aps 정보 포함)
        NotificationCenter.default.post(
            name: .navigateToChatRoom,
            object: nil,
            userInfo: userInfo // 전체 userInfo
        )
        
        completionHandler()
    }
    
    // APNs 토큰 수신 실패
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        Log.error("Remote notifications에 디바이스 토큰 저장 실패")
    }
}

extension AppDelegate: MessagingDelegate {
    
    // 토큰 갱신 모니터링
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        guard let fcmToken else { return }
        Log.debug("✅ firebase registration token: \(fcmToken)")
        let savedToken = deviceTokenManager.fetchToken(.deviceToken)
        
        guard !savedToken.isEmpty else {
            deviceTokenManager.saveDeviceToken(fcmToken)
            Log.debug("첫 디바이스토큰 저장 완료", "token: \(fcmToken)")
            return
        }
        
        guard fcmToken != savedToken else { return }
        deviceTokenManager.saveDeviceToken(fcmToken)
        deviceTokenManager.setDeviceTokenStatus(true)
        Log.debug("new 디바이스토큰 교체 완료", "token: \(fcmToken)")
    }
}


// MARK: NotificationCenter Name
extension Notification.Name {
    static let navigateToChatRoom = Notification.Name("navigateToChatRoom")
}

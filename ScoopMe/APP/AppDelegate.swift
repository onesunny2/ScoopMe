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
    
    private let deviceTokenManager = DIContainer.shared.deviceTokenManager
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        
        let notifiOption: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: notifiOption) { granted, error in
            
        }
        
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        Messaging.messaging().token { token, error in
            if let error = error {
                Log.debug("디바이스 토큰 수신 실패", "error: \(error)")
                return
            } else if let token = token {
                Log.debug("디바이스 토큰 수신 성공", "token: \(token)")
            }
            
        }
        
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // APNs 토큰 수신 성공 시
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", { $0 + String(format: "%02X", $1) })
        let savedToken = deviceTokenManager.fetchToken(.deviceToken)
        guard !savedToken.isEmpty else {
            deviceTokenManager.saveDeviceToken(deviceTokenString)
            Log.debug("첫 디바이스토큰 저장 완료", "token: \(deviceTokenString)")
            return
        }
        
        guard deviceTokenString != savedToken else { return }
        deviceTokenManager.saveDeviceToken(deviceTokenString)
        deviceTokenManager.setDeviceTokenStatus(true)
        Log.debug("new 디바이스토큰 교체 완료", "token: \(deviceTokenString)")
    }
    
    // APNs 토큰 수신 실패
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        Log.error("Remote notifications에 디바이스 토큰 저장 실패")
    }
}

extension AppDelegate: MessagingDelegate {
    
    // 토큰 갱신 모니터링
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Log.debug("✅ firebase registration token: \(String(describing: fcmToken))")
    }
}

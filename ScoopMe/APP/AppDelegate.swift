//
//  AppDelegate.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/15/25.
//

import UIKit
import UserNotifications
import SCMLogin

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    private let tokenManager: TokenManager
    
    override init() {
        self.tokenManager = TokenManager()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        
        let notifiOption: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: notifiOption) { granted, error in
            
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // APNs 토큰 수신 성공 시
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", { $0 + String(format: "%02X", $1) })
        let savedToken = tokenManager.fetchToken(.deviceToken)
        guard !savedToken.isEmpty else {
            tokenManager.saveDeviceToken(deviceTokenString)
            Log.debug("첫 디바이스토큰 저장 완료", "token: \(deviceTokenString)")
            return
        }
        
        guard deviceTokenString != savedToken else { return }
        tokenManager.saveDeviceToken(deviceTokenString)
        Log.debug("new 디바이스토큰 교체 완료", "token: \(deviceTokenString)")
    }
    
    // APNs 토큰 수신 실패
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        Log.error("Remote notifications에 디바이스 토큰 저장 실패")
    }
}

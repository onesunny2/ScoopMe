//
//  KakaoLoginConfiguration.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 5/12/25.
//

internal import KakaoSDKCommon
internal import KakaoSDKAuth

public enum KakaoLoginConfiguration {
    
    @MainActor
    public static func iniKakaoSDK(_ appkey: String) {
        KakaoSDK.initSDK(appKey: appkey)
    }
    
    /// URL 관련 처리는 보통 UI 업데이트를 동반함 -> main thread로 돌려주어야 함
    @MainActor
    public static func handleKakaoCallback(_ url: URL) -> Bool {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        return false
    }
}

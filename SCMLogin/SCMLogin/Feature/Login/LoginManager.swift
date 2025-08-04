//
//  LoginManager.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 5/13/25.
//

import Foundation
import Combine
import SCMLogger
import SCMNetwork

public final class LoginManager: NSObject, UserServiceProtocol {
    
    @Published public var loginFalied: Bool = false
    @Published public var alertMessage: String = ""
    
    public var alertTitle: String = "로그인 실패"
    
    public override init() {
        self.loginTokenManager = LoginTokenManager()
        self.deviceTokenManager = DeviceTokenManager()
        self.network = SCMNetworkImpl()
    }
    
    deinit {
        Log.debug("LoginManager deinit")
    }
    
    private let loginTokenManager: LoginTokenManager
    private let deviceTokenManager: DeviceTokenManager
    let network: SCMNetworkImpl
    
    @MainActor
    public func postAppleLogin(
        id token: String,
        _ deviceToken: String?,
        onSuccess: @escaping () async -> ()
    ) async {
        do {
            let value = LoginURL.appleLogin(id: token, device: deviceToken, nick: "sunny")
            let result = try await callRequest(value, type: LoginDTO.self)
            
            saveUserID(result.response.user_id)
            Log.debug("✅ 현재 UserID: \(UserdefaultsValues.savedUserID.stringValue)")
            await setTokens(result: result)
            await onSuccess()
        } catch {
            Log.error("❎ 애플 login error: \(error)")
            loginFalied = true
            handleError(error, &alertMessage)
        }
    }
    
    @MainActor
    public func postKakaoLogin(
        oauth token: String,
        _ deviceToken: String?,
        onSuccess: @escaping () async -> ()
    ) async {
        do {
            let value = LoginURL.kakaoLogin(oauth: token, device: deviceToken)
            let result = try await callRequest(value, type: LoginDTO.self)
            
            saveUserID(result.response.user_id)
            Log.debug("✅ 현재 UserID: \(UserdefaultsValues.savedUserID.stringValue)")
            await setTokens(result: result)
            await onSuccess()
        } catch {
            Log.error("❎ 카카오 login error: \(error)")
            loginFalied = true
            handleError(error, &alertMessage)
        }
    }
    
    @MainActor
    public func postEmailLogin(
        _ email: String,
        _ password: String,
        _ deviceToken: String?,
        onSuccess: @escaping () async -> ()
    ) async {
        do {
            let value = LoginURL.emailLogin(email: email, pw: password, device: deviceToken)
            let result = try await callRequest(value, type: LoginDTO.self)
            
            // 저장되어 있는 userID랑 현재 로그인 할 userID 다르면 재저장
            saveUserID(result.response.user_id)
            Log.debug("✅ 현재 UserID: \(UserdefaultsValues.savedUserID.stringValue)")
            await setTokens(result: result)
            await onSuccess()
        } catch {
            Log.error("❎ 이메일 login error: \(error)")
            loginFalied = true
            handleError(error, &alertMessage)
        }
    }
    
    // 디바이스토큰 달라질 시 update, 로그인 시 토큰 저장
    private func setTokens(result: HTTPResponse<LoginDTO>) async {
        
        loginTokenManager.saveLoginTokens(
            access: result.response.accessToken,
            refresh: result.response.refreshToken
        )
        
        let deviceToken = deviceTokenManager.fetchToken(.deviceToken)
        await deviceTokenManager.updateDeviceToken(deviceToken)
    }
    
    // 로그인 시 userID 저장
    private func saveUserID(_ userID: String) {
        let savedID = UserdefaultsValues.savedUserID.stringValue
        
        guard savedID == "" || savedID != userID else { return }
        UserDefaults.standard.set(userID, forKey: UserdefaultsValues.savedUserID.key)
        
        Log.debug("로그인 시 userID 저장 완료: \(userID) vs \(UserdefaultsValues.savedUserID.stringValue)")
    }
}

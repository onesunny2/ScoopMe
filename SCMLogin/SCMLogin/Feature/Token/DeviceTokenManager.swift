//
//  DeviceTokenManager.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 5/15/25.
//

import Foundation
import SCMLogger
import SCMNetwork

public final class DeviceTokenManager: NetworkEmptyProtocol {
    
    public init() {
        self.keychainManager = KeychainManager()
        self.network = SCMNetworkImpl()
    }
    
    private let keychainManager: KeychainManager
    let network: SCMNetworkImpl
    
    private let userdefaultsKey = "deviceTokenChanged"
    
    public func fetchToken(_ type: Keychain) -> String {
        do {
            let keychainManager = KeychainManager()
            let token = try keychainManager.getToken(for: type)
            return token
        } catch {
            Log.error("\(type.rawValue)의 토큰 정보를 불러오는데 실패했습니다.")
            return ""
        }
    }
    
    // device Token 저장
    public func saveDeviceToken(_ device: String) {
        do {
            try keychainManager.setToken(token: device, for: .deviceToken)
        } catch {
            Log.error("device Token 저장 실패")
        }
    }
    
    // deviceToken 업데이트
    public func updateDeviceToken(_ device: String) async {
        
        let tokenChangedStatus = UserDefaults.standard.bool(forKey: userdefaultsKey)
        guard tokenChangedStatus else {
            Log.info("디바이스 토큰 변경사항 없음")
            return
        }
        
        do {
            let accessToken = fetchToken(.accessToken)
            let value = LoginURL.updateDeviceToken(device: device, access: accessToken)
            let result = try await callEmptyRequest(value)
            
            Log.debug("deviceToken 업데이트 성공: Status Code \(result.statusCode)")
            
            setDeviceTokenStatus(false) // 한번 서버에 push 하면 다시 false로 변경
        } catch {
            Log.error("deviceToken 업데이트 실패: \(error)")
        }
    }
    
    // deviceToken 변경되면 호출
    public func setDeviceTokenStatus(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: userdefaultsKey)
    }
}

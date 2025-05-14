//
//  LoginManager.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 5/13/25.
//

import Foundation
internal import SCMNetwork

public final class LoginManager: UserServiceProtocol {
    
    public init() {
        self.network = SCMNetworkImpl()
    }
    
    let network: SCMNetworkImpl
    
    public func postAppleLogin(id token: String) async {
        do {
            let value = LoginURL.appleLogin(id: token, device: nil, nick: "sunny")
            let result = try await callRequest(value, type: LoginDTO.self)
            
            //            Log.debug("✅ 애플로그인 결과: \(result.response)")
            print("✅ 애플로그인 결과: \(result.response)")
            
        } catch {
            //            Log.error("❎ 애플 login error: \(error)")
            print("❎ 애플 login error: \(error)")
        }
    }
    
    public func postKakaoLogin(oauth token: String) async {
        do {
            let value = LoginURL.kakaoLogin(oauth: token, device: nil)
            let result = try await callRequest(value, type: LoginDTO.self)
            
            //            Log.debug("✅ 카카오로그인 결과: \(result.response)")
            print("✅ 카카오로그인 결과: \(result.response)")
        } catch {
            //            Log.error("❎ 카카오 login error: \(error)")
            print("❎ 카카오 login error: \(error)")
        }
    }
    
    public func postEmailLogin(_ email: String, _ password: String) async {
        do {
            let value = LoginURL.emailLogin(email: email, pw: password, device: nil)
            let result = try await callRequest(value, type: LoginDTO.self)
            
            //            Log.debug("✅ 이메일로그인 결과: \(result.response)")
            print("✅ 이메일로그인 결과: \(result.response)")
            
        } catch {
            //            Log.error("❎ 이메일 login error: \(error)")
            print("❎ 이메일 login error: \(error)")
        }
    }
}

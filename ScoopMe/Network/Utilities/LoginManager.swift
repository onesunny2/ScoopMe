//
//  LoginManager.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/13/25.
//

import Foundation
import SCMNetwork

final class LoginManager {
    
    static let shared = LoginManager()
    private init() {
        self.network = SCMNetworkImpl()
    }
    
    private let network: SCMNetworkImpl
    
    private func callRequest(_ value: LoginURL) async throws -> HTTPResponse<LoginDTO> {
        let request = HTTPRequest(
            scheme: .http,
            method: .post,
            successCodes: [200]
        )
            .addBaseURL(value.baseURL)
            .addPath(value.path)
            .addParamters(value.parameters)
            .addHeaders(value.headers)
        
        return try await network.fetchData(request, LoginDTO.self)
    }
    
    func postAppleLogin(id token: String) async {
        do {
            let value = LoginURL.appleLogin(id: token, device: nil, nick: "sunny")
            let result = try await callRequest(value)
            
            Log.debug("✅ 애플로그인 결과: \(result.response)")
            
        } catch {
            Log.error("❎ 애플 login error: \(error)")
        }
    }
    
    func postKakaoLogin(oauth token: String ) async {
        do {
            let value = LoginURL.kakaoLogin(oauth: token, device: nil)
            let result = try await callRequest(value)
            
            Log.debug("✅ 카카오로그인 결과: \(result.response)")
            
        } catch {
            Log.error("❎ 카카오 login error: \(error)")
        }
    }
    
    func postEmainLogin(_ email: String, _ password: String) async {
        do {
            let value = LoginURL.emailLogin(email: email, pw: password, device: nil)
            let result = try await callRequest(value)
            
            Log.debug("✅ 이메일로그인 결과: \(result.response)")
            
        } catch {
            Log.error("❎ 이메일 login error: \(error)")
        }
    }
}

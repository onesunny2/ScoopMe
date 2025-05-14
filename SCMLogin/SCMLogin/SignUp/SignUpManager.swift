//
//  SignUpManager.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 5/14/25.
//

import Foundation
internal import SCMNetwork

public final class SignUpManager {
    
    public static let shared = SignUpManager()
    private init() {
        self.network = SCMNetworkImpl()
    }
    
    private let network: SCMNetworkImpl
    
    private func callRequest(_ value: LoginURL) async throws -> HTTPResponse<EmailValidationDTO> {
        let request = HTTPRequest(
            scheme: .http,
            method: .post,
            successCodes: [200]
        )
            .addBaseURL(value.baseURL)
            .addPath(value.path)
            .addParamters(value.parameters)
            .addHeaders(value.headers)
        
        return try await network.fetchData(request, EmailValidationDTO.self)
    }
    
    public func postEmailValidation(_ email: String) async -> (title: String, message: String) {
        do {
            let value = LoginURL.checkEmail(email: email)
            let result = try await callRequest(value)
            
            print("✅ 중복확인 통과: \(result.response)")
//            Log.debug("✅ 중복확인 통과: \(result.response)")
            return ("사용가능", result.response.message)
        } catch {
            print("이메일 사용 불가: \(error)")
//            Log.error("이메일 사용 불가: \(error)")
            return ("\(error)", "\(error)")
        }
    }
}

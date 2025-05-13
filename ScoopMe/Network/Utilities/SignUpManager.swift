//
//  SignUpManager.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/13/25.
//

import Foundation
import SCMNetwork

final class SignUpManager {
    
    static let shared = SignUpManager()
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
    
    func postEmailValidation(_ email: String) async -> (title: String, message: String) {
        do {
            let value = LoginURL.checkEmail(email: email)
            let result = try await callRequest(value)
            
            Log.debug("✅ 중복확인 통과: \(result.response)")
            return ("사용가능", result.response.message)
        } catch {
            Log.error("이메일 사용 불가: \(error)")
            return ("\(error)", "\(error)")
        }
    }
}

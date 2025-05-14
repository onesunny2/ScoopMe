//
//  SignUpManager.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 5/14/25.
//

import Foundation
import Combine
internal import SCMNetwork

public final class SignUpManager: ObservableObject {
    
    @Published public var completeSignup: Bool = false
    @Published public var alertTitle: String = ""
    @Published public var alertMessage: String = ""
    @Published public var showAlert: Bool = false
    
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
    
    @MainActor
    public func postEmailValidation(_ email: String) async {
        do {
            let value = LoginURL.checkEmail(email: email)
            let result = try await callRequest(value)
            
            print("✅ 중복확인 통과: \(result.response)")
//            Log.debug("✅ 중복확인 통과: \(result.response)")
            alertTitle = "Success"
            alertMessage = result.response.message
        } catch {
            print("이메일 사용 불가: \(error)")
//            Log.error("이메일 사용 불가: \(error)")
            alertTitle = "Failed"
            alertMessage = "\(error)"
        }
    }
}

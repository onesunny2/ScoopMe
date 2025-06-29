//
//  SignUpManager.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 5/14/25.
//

import Foundation
import Combine
import SCMLogger
import SCMNetwork

public final class SignUpManager: UserServiceProtocol {
    
    @Published public var emailAvailable: Bool = false
    @Published public var successSignup: Bool = false
    @Published public var alertTitle: String = ""
    @Published public var alertMessage: String = ""
    
    public init() {
        self.network = SCMNetworkImpl()
    }
    
   let network: SCMNetworkImpl

    /// 이메일 유효성 서버통신
    @MainActor
    public func postEmailValidation(_ email: String) async {
        do {
            let value = LoginURL.checkEmail(email: email)
            let result = try await callRequest(value, type: EmailValidationDTO.self)
            
            Log.debug("✅ 중복확인 통과: \(result.response)")
            alertTitle = "Success"
            alertMessage = result.response.message
            emailAvailable = true
        } catch {
            Log.error("이메일 사용 불가: \(error)")
            alertTitle = "Failed"
            handleError(error, &alertMessage)
        }
    }
    
    /// 회원가입 서버통신
    @MainActor
    public func postSignupValidation(_ email: String, _ pw: String, _ nick: String, _ phone: String?) async {
        do {
            let value = LoginURL.join(
                email: email,
                pw: pw,
                nick: nick,
                phone: phone,
                device: nil
            )
            let result = try await callRequest(value, type: JoinResponseDTO.self)
            
            successSignup = true
            
            Log.debug("✅ 회원가입 완료: \(result.response)")
            
        } catch {
            Log.error("회원가입 실패")
        }
    }
}

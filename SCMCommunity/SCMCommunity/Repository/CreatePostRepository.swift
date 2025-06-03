//
//  CreatePostRepository.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 6/3/25.
//

import Foundation
import Combine
import SCMLogger
import SCMLogin
import SCMNetwork

public final class CreatePostRepository: CreatePostDisplayable {
    
    @Published public var showAlert: Bool = false
    @Published public var alertTitle: String = ""
    @Published public var alertMessage: String = ""
    
    private let loginTokenManager: LoginTokenManager
    private let network: SCMNetworkImpl
    
    public init() {
        self.loginTokenManager = LoginTokenManager()
        self.network = SCMNetworkImpl()
    }
    
    public func postFiles(_ files: [String]) async throws -> PostFilesEntity {
        
        let accessToken = loginTokenManager.fetchToken(.accessToken)
        let value = CommunityURL.fileUpload(access: accessToken, files: files)
        let result = try await callRequest(value, type: FileResponseDTO.self)
        
        let transFiles = result.response.files.map { Secret.baseURL + "/v1" + $0 }
        
        Log.debug("🔗 파일 업로드 성공: \(transFiles)")
        
        return PostFilesEntity(files: transFiles)
    }
    
    public func postContents(_ content: PostContent) async throws {
        
        let accessToken = loginTokenManager.fetchToken(.accessToken)
        let value = CommunityURL.postUpload(access: accessToken, value: content)
        let result = try await callRequest(value, type: PostResponseDTO.self)
        
        Log.debug("🔗 포스트 업로드 성공: \(result.response)")
    }
    
    public func checkTokenValidation(_ error: Error, complete: @escaping () async throws -> ()) async {
        if let scmError = error as? SCMError {
            switch scmError {
            case .serverError(let statusCode, _):
                switch statusCode {
                case 419: // access 만료 -> refresh 통신 진행
                    Log.debug("✅ accessToken만료")
                    await checkRefreshToken(complete: complete)
                case 401, 418: // refresh 토큰 오류 및 만료 -> 로그인 화면으로 보내기
                    loginTokenManager.alertTitle = "안내"
                    loginTokenManager.alertMessage = "세션이 만료되었습니다. 다시 로그인해주세요."
                    showAlert = true
                default:
                    Log.error("❎ 서버통신 오류: \(error)")
                    break
                }
            default: break
            }
        }
    }
}

// MARK: private action
extension CreatePostRepository {
    
    private func callRequest<T: Decodable>(_ value: CommunityURL, type: T.Type) async throws -> HTTPResponse<T> {
        let request = HTTPRequest(
            scheme: .http,
            method: value.method,
            successCodes: [200]
        )
            .addBaseURL(value.baseURL)
            .addPath(value.path)
            .addParameters(value.parameters)
            .addJSONBody(value.jsonBody)
            .addHeaders(value.headers)
        
        return try await network.fetchData(request, T.self)
    }
    
    private func checkRefreshToken(complete: @escaping () async throws -> ()) async {
        do {
            try await loginTokenManager.requestRefreshToken()
            try await complete()
        } catch {
            alertTitle = "안내"
            alertMessage = "세션이 만료되었습니다. 다시 로그인해주세요."
            showAlert = true
        }
    }
}

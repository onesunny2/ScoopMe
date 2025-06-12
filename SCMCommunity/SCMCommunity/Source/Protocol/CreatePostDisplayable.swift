//
//  CreatePostDisplayable.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 6/3/25.
//

import Foundation
import SCMLogger
import SCMLogin
import SCMNetwork

public protocol CreatePostDisplayable: AnyObject {
    
    var loginTokenManager: LoginTokenManager { get }
    var network: SCMNetworkImpl { get }
    
    func postFiles(_ files: [FileData]) async throws -> PostFilesEntity
    func postContents(_ content: PostContent) async throws
    
    func callRequest<T: Decodable>(_ value: CommunityURL, type: T.Type) async throws -> HTTPResponse<T>
    func callMultipartRequest<T: Decodable>(_ value: CommunityURL, type: T.Type) async throws -> HTTPResponse<T>
    func checkRefreshToken(complete: @escaping () async throws -> ()) async
    func checkTokenValidation(_ error: Error, complete: @escaping () async throws -> ()) async
}

extension CreatePostDisplayable {
    
    public func callRequest<T: Decodable>(_ value: CommunityURL, type: T.Type) async throws -> HTTPResponse<T> {
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
    
    public func callMultipartRequest<T: Decodable>(_ value: CommunityURL, type: T.Type) async throws -> HTTPResponse<T> {
        let request = HTTPRequest(
            scheme: .http,
            method: value.method,
            successCodes: [200]
        )
            .addBaseURL(value.baseURL)
            .addPath(value.path)
            .addParameters(value.parameters)
            .addMultipartData(value.multipartData!)
            .addHeaders(value.headers)
        
        return try await network.fetchData(request, T.self)
    }
    
    public func checkRefreshToken(complete: @escaping () async throws -> ()) async {
        do {
            try await loginTokenManager.requestRefreshToken()
            try await complete()
        } catch {
            
        }
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
                default:
                    Log.error("❎ 서버통신 오류: \(error)")
                    break
                }
            default: break
            }
        }
    }
}

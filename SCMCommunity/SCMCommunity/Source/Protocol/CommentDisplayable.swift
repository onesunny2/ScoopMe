//
//  CommentDisplayable.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 8/7/25.
//

import Foundation
import SCMLogin
import SCMNetwork

public protocol CommentDisplayable: AnyObject {
    var loginTokenManager: LoginTokenManager { get }
    var network: SCMNetworkImpl { get }
    
    func postComment(postID: String, content: PostComment) async throws -> CommentResponseDTO
    func editComment(comment: CommentInfo) async throws -> CommentResponseDTO
    func deleteComment(postID: String, commentID: String) async throws
    
    func callRequest<T: Decodable>(_ value: CommentURL, type: T.Type) async throws -> HTTPResponse<T>
    func callEmptyRequest(_ value: CommentURL) async throws -> HTTPResponse<EmptyResponse>
    func checkRefreshToken(complete: @escaping () async throws -> ()) async
}

extension CommentDisplayable {
    
    public func callRequest<T: Decodable>(_ value: CommentURL, type: T.Type) async throws -> HTTPResponse<T> {
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
    
    public func callEmptyRequest(_ value: CommentURL) async throws -> HTTPResponse<EmptyResponse> {
        let request = HTTPRequest(
            scheme: .http,
            method: value.method,
            successCodes: [200] // 200 OK
        )
            .addBaseURL(value.baseURL)
            .addPath(value.path)
            .addJSONBody(value.jsonBody)
            .addHeaders(value.headers)
        
        return try await network.fetchEmptyData(request)
    }
    
    public func checkRefreshToken(complete: @escaping () async throws -> ()) async {
        do {
            try await loginTokenManager.requestRefreshToken()
            try await complete()
        } catch {
            // TODO: 만료되면 로그인 화면으로 돌아가도록 처리 필요
        }
    }
}

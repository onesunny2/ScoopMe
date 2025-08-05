//
//  CommunityPostDisplayable.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 5/30/25.
//

import Foundation
import SCMLocation
import SCMLogin
import SCMNetwork

public protocol CommunityPostDisplayable: AnyObject {
    typealias postForPagination = (data: [CommunityPostEntity], next: String)
    
    var locationManager: LocationManager { get }
    var loginTokenManager: LoginTokenManager { get }
    var network: SCMNetworkImpl { get }
    
    func getCommunityPost(max distance: Int, orderBy: TimelineFilter, next: String?) async throws -> postForPagination
    func deleteCommunityPost(postID: String) async throws
    func postStoreLikeStatus(store id: String, like status: Bool) async throws
    
    func callRequest<T: Decodable>(_ value: CommunityURL, type: T.Type) async throws -> HTTPResponse<T>
    func callEmptyRequest(_ value: CommunityURL) async throws -> HTTPResponse<EmptyResponse>
    func checkRefreshToken(complete: @escaping () async throws -> ()) async
}

extension CommunityPostDisplayable {
    
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
    
    public func callEmptyRequest(_ value: CommunityURL) async throws -> HTTPResponse<EmptyResponse> {
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

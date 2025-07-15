//
//  ChatNetworkProvider.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/16/25.
//

import Foundation
import SCMLogin
import SCMNetwork

protocol ChatNetworkProvider: AnyObject {
    var network: SCMNetworkImpl { get }
    var loginTokenManager: LoginTokenManager { get }
    
    func callRequest<T: Decodable>(_ value: ChatURL, type: T.Type) async throws -> HTTPResponse<T>
}

extension ChatNetworkProvider {
    
    public func callRequest<T: Decodable>(_ value: ChatURL, type: T.Type) async throws -> HTTPResponse<T> {
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
}

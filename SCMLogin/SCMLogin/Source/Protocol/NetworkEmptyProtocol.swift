//
//  NetworkEmptyProtocol.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 5/16/25.
//

import Foundation
internal import SCMNetwork

protocol NetworkEmptyProtocol: NetworkServiceProtocol {
    var network: SCMNetworkImpl { get }
    
    func callEmptyRequest(_ value: LoginURL) async throws -> HTTPResponse<EmptyResponse> 
}

extension NetworkEmptyProtocol {
    
    func callEmptyRequest(_ value: LoginURL) async throws -> HTTPResponse<EmptyResponse> {
        let request = HTTPRequest(
            scheme: .http,
            method: value.method,
            successCodes: [200] // 200 OK
        )
            .addBaseURL(value.baseURL)
            .addPath(value.path)
            .addParameters(value.parameters)
            .addHeaders(value.headers)
        
        return try await network.fetchEmptyData(request)
    }
}

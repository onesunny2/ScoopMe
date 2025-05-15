//
//  NetworkServiceProtocol.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 5/15/25.
//

import Foundation
internal import SCMNetwork

protocol NetworkServiceProtocol: AnyObject {
    var network: SCMNetworkImpl { get }
    
    func callRequest<T: Decodable>(_ value: LoginURL, type: T.Type) async throws -> HTTPResponse<T>
}

extension NetworkServiceProtocol {
    
    func callRequest<T: Decodable>(_ value: LoginURL, type: T.Type) async throws -> HTTPResponse<T> {
        let request = HTTPRequest(
            scheme: .http,
            method: value.method,
            successCodes: [200]
        )
            .addBaseURL(value.baseURL)
            .addPath(value.path)
            .addParamters(value.parameters)
            .addHeaders(value.headers)
        
        return try await network.fetchData(request, T.self)
    }
}

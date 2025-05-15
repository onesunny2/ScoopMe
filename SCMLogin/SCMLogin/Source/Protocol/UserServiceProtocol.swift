//
//  UserServiceProtocol.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 5/14/25.
//

import Foundation
import Combine
internal import SCMNetwork

protocol UserServiceProtocol: ObservableObject, AnyObject {
    
    var alertTitle: String { get set }
    var alertMessage: String { get set }
    var network: SCMNetworkImpl { get }
    
    func callRequest<T: Decodable>(_ value: LoginURL, method: HTTPMethods, type: T.Type) async throws -> HTTPResponse<T>
}

extension UserServiceProtocol {
    
    func callRequest<T: Decodable>(_ value: LoginURL, method: HTTPMethods, type: T.Type) async throws -> HTTPResponse<T> {
        let request = HTTPRequest(
            scheme: .http,
            method: method,
            successCodes: [200]
        )
            .addBaseURL(value.baseURL)
            .addPath(value.path)
            .addParamters(value.parameters)
            .addHeaders(value.headers)
        
        return try await network.fetchData(request, T.self)
    }
    
    @MainActor
    func handleError(_ error: Error, _ alertMessage: inout String) {
        
        guard let scmError = error as? SCMError else { return }
        
        switch scmError {
        case .serverError(_, let message):
            alertMessage = message
        default:
            alertMessage = scmError.localizedDescription
        }
    }
}

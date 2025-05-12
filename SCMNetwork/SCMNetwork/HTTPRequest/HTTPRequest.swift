//
//  HTTPRequest.swift
//  SCMNetwork
//
//  Created by Lee Wonsun on 5/11/25.
//

import Foundation

public struct HTTPRequest {
    private let scheme: Schemes
    private var baseURL: String = ""
    private let method: HTTPMethods
    private var path: String = ""
    private var parameters: [String: String?]? = nil
    private var httpHeaders: [String: String] = [:]
    
    public init(scheme: Schemes, method: HTTPMethods) {
        self.scheme = scheme
        self.method = method
    }
}

extension HTTPRequest: Requestable {
    
    public var urlString: String {
        return "\(scheme.string)://\(baseURL)\(path)"
    }
    
    public func addBaseURL(_ url: String) -> Self {
        var request = self
        request.baseURL = url
        return request
    }
    
    public func addPath(_ path: String) -> Self {
        var request = self
        request.path = path
        return request
    }
    
    public func addParamters(_ params: [String: String?]?) -> Self {
        var request = self
        request.parameters = params
        return request
    }
    
    public func addHeaders(_ headers: [String: String]) -> Self {
        var request = self
        request.httpHeaders = headers
        return request
    }
    
    public func urlRequest() throws -> URLRequest {
        
        guard let url = URL(string: urlString) else { throw SCMError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // header
        for (key, value) in httpHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // parameter
        if let parameters {
            switch method {
            case .get:
                var components = URLComponents(string: urlString)
                components?.queryItems = parameters.map {
                    URLQueryItem(name: $0.key, value: $0.value)
                }
                guard let url = components?.url else { throw SCMError.invalidURL }
                request.url = url
                
            case .post, .put:
                do {
                    let nonNilParameters = parameters.compactMapValues { $0 }
                    let jsonData = try JSONSerialization.data(withJSONObject: nonNilParameters, options: [])
                    request.httpBody = jsonData
                } catch {
                    throw SCMError.invalidParameter
                }
                
            default: break
            }
        }
        
        return request
    }
}

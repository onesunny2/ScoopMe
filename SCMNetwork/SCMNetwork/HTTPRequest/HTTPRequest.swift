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
    private var jsonBody: [String: Any]? = nil
    private var multipartData: MultipartFormData? = nil 
    private var httpHeaders: [String: String] = [:]
    private var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    private var successStatusCodes: Set<Int>
    
    public init(scheme: Schemes, method: HTTPMethods, successCodes: Set<Int>) {
        self.scheme = scheme
        self.method = method
        self.successStatusCodes = successCodes
    }
}

extension HTTPRequest: Requestable {
    
    public var successCodes: Set<Int> {
        return successStatusCodes
    }
    
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
    
    public func addParameters(_ params: [String: String?]?) -> Self {
        var request = self
        request.parameters = params
        return request
    }
    
    public func addJSONBody(_ body: [String: Any]?) -> Self {
        var request = self
        request.jsonBody = body
        return request
    }
    
    public func addMultipartData(_ multipartData: MultipartFormData?) -> Self {
        var request = self
        request.multipartData = multipartData
        return request
    }
    
    public func addHeaders(_ headers: [String: String]) -> Self {
        var request = self
        request.httpHeaders = headers
        return request
    }
    
    public func setCachePolicy(_ policy: URLRequest.CachePolicy) -> Self {
        var request = self
        request.cachePolicy = policy
        return request
    }
    
    public func urlRequest() throws -> URLRequest {
        
        guard let url = URL(string: urlString) else { throw SCMError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // cachePolicy
        request.cachePolicy = cachePolicy
        
        // header
        for (key, value) in httpHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        switch method {
        case .get:
            if let parameters {
                var components = URLComponents(string: urlString)
                components?.queryItems = parameters.map {
                    URLQueryItem(name: $0.key, value: $0.value)
                }
                guard let url = components?.url else { throw SCMError.invalidURL }
                request.url = url
            }
            
        case .post, .put:
            if let multipartData = multipartData {
                request.setValue(multipartData.contentType, forHTTPHeaderField: "Content-Type")
                request.httpBody = multipartData.httpBody
            } else if let jsonBody {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: jsonBody, options: [])
                    request.httpBody = jsonData
                } catch {
                    throw SCMError.invalidParameter
                }
            }
            
        default: break
        }
        
        return request
    }
}

//
//  Requestable.swift
//  SCMNetwork
//
//  Created by Lee Wonsun on 5/12/25.
//

import Foundation

public protocol Requestable {
    var urlString: String { get }
    
    func addBaseURL(_ url: String) -> Self
    func addPath(_ path: String) -> Self
    func addParameters(_ params: [String: String?]?) -> Self
    func addJSONBody(_ body: [String: Any]?) -> Self
    func addMultipartData(_ multipartData: MultipartFormData?) -> Self
    func addHeaders(_ headers: [String: String]) -> Self
    func urlRequest() throws -> URLRequest
}

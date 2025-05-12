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
    func addParamters(_ params: [String: String?]?) -> Self
    func addHeaders(_ headers: [String: String]) -> Self
    func urlRequest() throws -> URLRequest
}

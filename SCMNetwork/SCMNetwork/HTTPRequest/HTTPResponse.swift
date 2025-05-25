//
//  HTTPResponse.swift
//  SCMNetwork
//
//  Created by Lee Wonsun on 5/12/25.
//

import Foundation

public struct HTTPResponse<T: Decodable>: Responsable {
    public typealias ResponseType = T
    
    public var statusCode: Int
    public var response: ResponseType
    public var headers: [String : String]?
    
    public init(statusCode: Int, response: ResponseType, headers: [String : String]? = nil) {
        self.statusCode = statusCode
        self.response = response
        self.headers = headers
    }
}

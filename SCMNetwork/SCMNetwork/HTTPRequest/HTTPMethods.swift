//
//  HTTPMethods.swift
//  SCMNetwork
//
//  Created by Lee Wonsun on 5/11/25.
//

import Foundation

public enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    
    public var string: String {
        return self.rawValue
    }
}

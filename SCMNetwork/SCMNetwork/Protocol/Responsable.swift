//
//  Responsable.swift
//  SCMNetwork
//
//  Created by Lee Wonsun on 5/12/25.
//

import Foundation

public protocol Responsable {
    associatedtype ResponseType
    
    var statusCode: Int { get }
    var response: ResponseType { get }
    var headers: [String: String]? { get }
}

//
//  NetworkManager.swift
//  SCMNetwork
//
//  Created by Lee Wonsun on 5/12/25.
//

import Foundation

public protocol NetworkManager {
    func fetchData<T: Decodable>(_ request: HTTPRequest, _ type: T.Type) async throws -> HTTPResponse<T>
}

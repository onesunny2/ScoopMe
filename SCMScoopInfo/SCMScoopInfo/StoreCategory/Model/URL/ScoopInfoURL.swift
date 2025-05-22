//
//  ScoopInfoURL.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/22/25.
//

import Foundation
internal import SCMNetwork

public enum ScoopInfoURL {
    case popularKeyword(access: String)
    
    var baseURL: String {
        return Secret.baseURL
    }
    
    var method: HTTPMethods {
        switch self {
        case .popularKeyword:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .popularKeyword: "/v1/stores/searches-popular"
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        default: return nil
        }
    }
    
    var headers: [String: String] {
        switch self {
        case let .popularKeyword(access):
            return [
                "Content-Type": "application/json",
                "SeSACKey": Secret.apiKey,
                "Authorization": access
            ]
        }
    }
}

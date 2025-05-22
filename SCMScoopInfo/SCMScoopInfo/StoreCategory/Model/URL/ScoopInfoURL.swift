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
    case realtimePopularStores(access: String, category: Category)
    
    var baseURL: String {
        return Secret.baseURL
    }
    
    var method: HTTPMethods {
        switch self {
        default:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .popularKeyword: "/v1/stores/searches-popular"
        case .realtimePopularStores: "v1/stores/popular-stores"
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case let .realtimePopularStores(_, category):
            return ["category" : category.text]
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
        case let .realtimePopularStores(access, _):
            return [
                "Content-Type": "application/json",
                "SeSACKey": Secret.apiKey,
                "Authorization": access
            ]
        }
    }
}

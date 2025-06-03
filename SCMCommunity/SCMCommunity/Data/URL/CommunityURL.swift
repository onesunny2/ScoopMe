//
//  CommunityURL.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 6/3/25.
//

import Foundation
import SCMNetwork

public enum CommunityURL {
    case fileUpload(access: String, files: [String])
    
    var baseURL: String {
        return Secret.baseURL
    }
    
    var method: HTTPMethods {
        switch self {
        case .fileUpload:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .fileUpload: "/v1/posts/files"
        }
    }
    
    var parameters: [String: String?]? {
        switch self {
        default: return nil
        }
    }
    
    var jsonBody: [String: Any?]? {
        switch self {
        default: return nil
        }
    }
    
    var headers: [String: String] {
        switch self {
        case let .fileUpload(access, _):
            return [
                "Content-Type": "multipart/form-data",
                "SeSACKey": Secret.apiKey,
                "Authorization": access
            ]
        }
    }
}

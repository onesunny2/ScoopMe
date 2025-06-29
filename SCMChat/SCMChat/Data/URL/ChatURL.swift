//
//  ChatURL.swift
//  SCMChat
//
//  Created by Lee Wonsun on 6/19/25.
//

import Foundation
import SCMNetwork

public enum ChatURL {
    case fetchChatRoom(access: String, opponentUserid: String)
    case loadChatRoom(access: String)
    
    var baseURL: String {
        return Secret.baseURL
    }
    
    var method: HTTPMethods {
        switch self {
        case .fetchChatRoom:
            return .post
        case .loadChatRoom:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchChatRoom, .loadChatRoom:
            return "/v1/chats"
        }
    }
    
    var parameters: [String: String?]? {
        switch self {
        default:
            return nil
        }
    }
    
    var jsonBody: [String: Any?]? {
        switch self {
        case let .fetchChatRoom(_, opponentUserid):
            return [
                "opponent_id": opponentUserid
            ]
        default:
            return nil
        }
    }
    
    var headers: [String: String] {
        switch self {
        case let .fetchChatRoom(access, _):
            return [
                "Content-Type": "application/json",
                "SeSACKey": Secret.apiKey,
                "Authorization": access
            ]
        case let .loadChatRoom(access):
            return [
                "Content-Type": "application/json",
                "SeSACKey": Secret.apiKey,
                "Authorization": access
            ]
        }
    }
}

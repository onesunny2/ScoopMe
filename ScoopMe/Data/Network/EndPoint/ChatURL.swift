//
//  ChatURL.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/16/25.
//

import Foundation
import SCMNetwork

enum ChatURL {
    case fetchChatRoom(access: String, opponentUserid: String)
    case loadChatRoom(access: String)
    case postMessage(access: String, messageInfo: PostMessages)
    case getMessages(access: String, messageInfo: GetMessages)
    case checkUserExisted(access: String, nickname: String)
    case fetchMainUser(access: String)
    
    var baseURL: String {
        return Secret.baseURL
    }
    
    var method: HTTPMethods {
        switch self {
        case .fetchChatRoom, .postMessage:
            return .post
        case .loadChatRoom, .getMessages, .checkUserExisted, .fetchMainUser:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchChatRoom, .loadChatRoom:
            return "/v1/chats"
        case let .postMessage(_, info):
            return "/v1/chats/\(info.roomID)"
        case let .getMessages(_, info):
            return "/v1/chats/\(info.roomID)"
        case .checkUserExisted:
            return "/v1/users/search"
        case .fetchMainUser:
            return "/v1/users/me/profile"
        }
    }
    
    var parameters: [String: String?]? {
        switch self {
        case let .getMessages(_, info):
            return [
                "room_id": info.roomID,
                "next": info.lastMessageDate
            ]
        case let .checkUserExisted(_, nickname):
            return [
                "nick": nickname
            ]
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
        case let .postMessage(_, info):
            return [
                "content": info.contents,
                "files": info.files
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
        case let .postMessage(access, _):
            return [
                "Content-Type": "application/json",
                "SeSACKey": Secret.apiKey,
                "Authorization": access
            ]
        case let .getMessages(access, _):
            return [
                "Content-Type": "application/json",
                "SeSACKey": Secret.apiKey,
                "Authorization": access
            ]
        case let .checkUserExisted(access, _):
            return [
                "Content-Type": "application/json",
                "SeSACKey": Secret.apiKey,
                "Authorization": access
            ]
        case let .fetchMainUser(access):
            return [
                "Content-Type": "application/json",
                "SeSACKey": Secret.apiKey,
                "Authorization": access
            ]
        }
    }
}

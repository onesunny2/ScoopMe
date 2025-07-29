//
//  SCMRealmError.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/16/25.
//

import Foundation

enum SCMRealmError: Error {
    case roomNotFound
    case messageNotFound
    case cannotDeleteMessage
    
    var localizedDescription: String {
        switch self {
        case .roomNotFound:
            return "채팅방을 찾을 수 없습니다."
        case .messageNotFound:
            return "메시지를 찾을 수 없습니다."
        case .cannotDeleteMessage:
            return "삭제가능한 메시지가 없습니다."
        }
    }
}

//
//  ChatListResponseDTO.swift
//  SCMChat
//
//  Created by Lee Wonsun on 6/24/25.
//

import Foundation

// MARK: 최상위 응답 DTO
struct ChatListResponseDTO: Codable {
    let data: [ChatResponseDTO]
}

// MARK: 개별 채팅 메시지 DTO
struct ChatResponseDTO: Codable {
    let chatId: String
    let roomId: String
    let content: String
    let createdAt: String
    let updatedAt: String
    let sender: UserInfoResponseDTO
    let files: [String]
    
    enum CodingKeys: String, CodingKey {
        case chatId = "chat_id"
        case roomId = "room_id"
        case content
        case createdAt
        case updatedAt
        case sender
        case files
    }
    
    // Date 변환 헬퍼
    var createdDate: Date {
        return ISO8601DateFormatter().date(from: createdAt) ?? Date()
    }
    
    var updatedDate: Date {
        return ISO8601DateFormatter().date(from: updatedAt) ?? Date()
    }
}

// MARK: 사용자 정보 DTO
struct UserInfoResponseDTO: Codable {
    let userId: String
    let nick: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
        case profileImage
    }
}

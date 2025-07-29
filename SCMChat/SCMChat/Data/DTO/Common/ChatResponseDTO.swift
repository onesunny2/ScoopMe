//
//  ChatResponseDTO.swift
//  SCMChat
//
//  Created by Lee Wonsun on 6/29/25.
//

import Foundation

struct ChatResponseDTO: Codable {
    let chatID: String
    let roomID: String
    let content: String
    let createdAt: String
    let updatedAt: String
    let sender: UserInfoResponseDTO
    let files: [String]

    enum CodingKeys: String, CodingKey {
        case chatID = "chat_id"
        case roomID = "room_id"
        case content
        case createdAt
        case updatedAt
        case sender
        case files
    }
}

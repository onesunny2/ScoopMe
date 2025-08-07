//
//  ChatResponseDTO.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/16/25.
//

import Foundation

struct ChatResponseDTO: Codable {
    let chatID: String
    let roomID: String
    let content: String
    let createdAt: String
    let updatedAt: String
    let sender: UserInfoResponseCoreDTO
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

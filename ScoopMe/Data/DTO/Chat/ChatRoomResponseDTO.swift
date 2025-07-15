//
//  ChatRoomResponseDTO.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/16/25.
//

import Foundation

struct ChatRoomResponseDTO: Codable {
    let roomID: String
    let createdAt: String
    let updatedAt: String
    let participants: [UserInfoResponseDTO]
    let lastChat: ChatResponseDTO?

    enum CodingKeys: String, CodingKey {
        case roomID = "room_id"
        case createdAt
        case updatedAt
        case participants
        case lastChat
    }
}

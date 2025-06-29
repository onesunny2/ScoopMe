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

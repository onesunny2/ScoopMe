//
//  ChatListResponseDTO.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/16/25.
//

import Foundation

// MARK: 최상위 응답 DTO
struct ChatListResponseDTO: Codable {
    let data: [ChatResponseDTO]
}

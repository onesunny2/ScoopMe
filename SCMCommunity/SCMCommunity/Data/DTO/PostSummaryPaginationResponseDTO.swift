//
//  PostSummaryPaginationResponseDTO.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 6/8/25.
//

import Foundation

struct PostSummaryPaginationResponseDTO: Codable {
    let data: [PostSummaryResponseDTO]
    let nextCursor: String

    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
}

struct PostSummaryResponseDTO: Codable {
    let postId: String
    let category: String
    let title: String
    let content: String
    let store: StoreSummaryDTOCommunity?
    let geolocation: Geolocation
    let creator: UserInfoResponseDTO
    let files: [String]
    let isLike: Bool
    let likeCount: Double
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case category, title, content, store, geolocation, creator, files
        case isLike = "is_like"
        case likeCount = "like_count"
        case createdAt, updatedAt
    }
}

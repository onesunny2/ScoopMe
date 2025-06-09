//
//  PostResponseDTO.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 6/3/25.
//

import Foundation

struct PostResponseDTO: Codable {
    let postId: String
    let category: String
    let title: String
    let content: String
    let store: StoreSummaryDTOCommunity?
    let geolocation: Geolocation
    let creator: UserInfoResponseDTO
    let files: [String]
    let isLike: Bool
    let likeCount: Int
    let comments: [CommentResponseDTO]
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case category, title, content, store, geolocation, creator, files
        case isLike = "is_like"
        case likeCount = "like_count"
        case comments, createdAt, updatedAt
    }
}

struct CommentResponseDTO: Codable {
    let commentId: String
    let content: String
    let createdAt: String
    let creator: UserInfoResponseDTO
    let replies: [ReplyDTO]

    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case content, createdAt, creator, replies
    }
}

struct ReplyDTO: Codable {
    let commentId: String
    let content: String
    let createdAt: String
    let creator: UserInfoResponseDTO

    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case content, createdAt, creator
    }
}


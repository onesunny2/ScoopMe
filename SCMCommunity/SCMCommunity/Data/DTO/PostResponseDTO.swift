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

public struct CommentResponseDTO: Hashable, Codable {
    public let commentId: String
    public let content: String
    public let createdAt: String
    public let creator: UserInfoResponseDTO
    public let replies: [ReplyDTO]?

    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case content, createdAt, creator, replies
    }
    
    public init(
        commentId: String,
        content: String,
        createdAt: String,
        creator: UserInfoResponseDTO,
        replies: [ReplyDTO]?
    ) {
        self.commentId = commentId
        self.content = content
        self.createdAt = createdAt
        self.creator = creator
        self.replies = replies
    }
}

public struct ReplyDTO: Hashable, Codable {
    public let commentId: String
    public let content: String
    public let createdAt: String
    public let creator: UserInfoResponseDTO

    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case content, createdAt, creator
    }
    
    public init(
        commentId: String,
        content: String,
        createdAt: String,
        creator: UserInfoResponseDTO
    ) {
        self.commentId = commentId
        self.content = content
        self.createdAt = createdAt
        self.creator = creator
    }
}


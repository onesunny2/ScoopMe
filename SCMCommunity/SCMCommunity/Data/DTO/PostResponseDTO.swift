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

struct StoreSummaryDTOCommunity: Codable {
    let id: String
    let category: String
    let name: String
    let close: String
    let storeImageUrls: [String]
    let isPicchelin: Bool
    let isPick: Bool
    let pickCount: Int
    let hashTags: [String]
    let totalRating: Float
    let totalOrderCount: Int
    let totalReviewCount: Int
    let geolocation: Geolocation
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, category, name, close
        case storeImageUrls = "store_image_urls"
        case isPicchelin = "is_picchelin"
        case isPick = "is_pick"
        case pickCount = "pick_count"
        case hashTags, totalRating = "total_rating", totalOrderCount = "total_order_count", totalReviewCount = "total_review_count"
        case geolocation, createdAt, updatedAt
    }
}

struct Geolocation: Codable {
    let longitude: Double
    let latitude: Double
}

struct UserInfoResponseDTO: Codable {
    let userId: String
    let nick: String
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick, profileImage
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


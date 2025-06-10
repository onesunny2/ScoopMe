//
//  StoreSummaryDTOCommunity.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 6/8/25.
//

import Foundation

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

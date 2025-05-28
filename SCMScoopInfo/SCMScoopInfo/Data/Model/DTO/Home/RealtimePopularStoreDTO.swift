//
//  RealtimePopularStoreDTO.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/22/25.
//

import Foundation

struct RealtimePopularStoreDTO: Codable {
    let data: [RealtimePopularStoreResponse]
}

struct RealtimePopularStoreResponse: Codable {
    let storeID: String
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
        case storeID = "store_id"
        case category
        case name
        case close
        case storeImageUrls = "store_image_urls"
        case isPicchelin = "is_picchelin"
        case isPick = "is_pick"
        case pickCount = "pick_count"
        case hashTags
        case totalRating = "total_rating"
        case totalOrderCount = "total_order_count"
        case totalReviewCount = "total_review_count"
        case geolocation
        case createdAt
        case updatedAt
    }
}

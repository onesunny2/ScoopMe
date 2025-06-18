//
//  StoreSummaryDTOOrder.swift
//  SCMPayment
//
//  Created by Lee Wonsun on 6/13/25.
//

import Foundation

struct StoreSummaryDTOOrder: Codable {
    let id, category, name, close: String
    let storeImageUrls: [String]
    let hashTags: [String]
    let geolocation: Geolocation
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, category, name, close
        case storeImageUrls = "store_image_urls"
        case hashTags
        case geolocation
        case createdAt
        case updatedAt
    }
}

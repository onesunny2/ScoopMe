//
//  AroundStoreInfoEntity.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/20/25.
//

import Foundation

public struct AroundStoreInfoEntity: Hashable {
    let storeID: String
    let storeName: String
    let storeImage: [String]
    let likeStatus: Bool
    let picchelinStatus: Bool
    let likeCount: String
    let totalRating: String
    let distance: String
    let closeTime: String
    let orderCount: String
    let hashTags: [String]
}

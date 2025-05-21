//
//  AroundStoreInfoEntity.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/20/25.
//

import Foundation

public struct AroundStoreInfoEntity: Hashable {
    public let storeID: String
    public let storeName: String
    public let storeImage: [String]
    public let likeStatus: Bool
    public let picchelinStatus: Bool
    public let likeCount: String
    public let totalRating: String
    public let distance: String
    public let closeTime: String
    public let orderCount: String
    public let hashTags: [String]
    
    public init(
        storeID: String,
        storeName: String,
        storeImage: [String],
        likeStatus: Bool,
        picchelinStatus: Bool,
        likeCount: String,
        totalRating: String,
        distance: String,
        closeTime: String,
        orderCount: String,
        hashTags: [String]
    ) {
        self.storeID = storeID
        self.storeName = storeName
        self.storeImage = storeImage
        self.likeStatus = likeStatus
        self.picchelinStatus = picchelinStatus
        self.likeCount = likeCount
        self.totalRating = totalRating
        self.distance = distance
        self.closeTime = closeTime
        self.orderCount = orderCount
        self.hashTags = hashTags
    }
}

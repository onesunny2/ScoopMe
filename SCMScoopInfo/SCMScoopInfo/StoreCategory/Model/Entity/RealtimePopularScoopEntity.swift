//
//  RealtimePopularScoopEntity.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/20/25.
//

import SwiftUI

public struct RealtimePopularScoopEntity: Hashable {
    public let storeID: String
    public let storeName: String
    public let storeImage: String
    public let likeStatus: Bool
    public let picchelinStatus: Bool
    public let likeCount: String
    public let distance: String
    public let orderCount: String
    
    public init(
            storeID: String,
            storeName: String,
            storeImage: String,
            likeStatus: Bool,
            picchelinStatus: Bool,
            likeCount: String,
            distance: String,
            orderCount: String
        ) {
            self.storeID = storeID
            self.storeName = storeName
            self.storeImage = storeImage
            self.likeStatus = likeStatus
            self.picchelinStatus = picchelinStatus
            self.likeCount = likeCount
            self.distance = distance
            self.orderCount = orderCount
        }
}

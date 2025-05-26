//
//  StoreDetailInfoEntity.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/26/25.
//

import Foundation

public struct StoreDetailInfoEntity: Hashable {
    public let storeID: String
    public let storeName: String
    public let imageUrls: [String]
    public let picchelinStatus: Bool
    public var likeStatus: Bool
    public let address: String
    public let parkingInfo: String
    public let time: String
    public let rating: String
    public let review: String
    public let distance: String
    
    public init(
        storeID: String,
        storeName: String,
        imageUrls: [String],
        picchelinStatus: Bool,
        likeStatus: Bool,
        address: String,
        parkingInfo: String,
        time: String,
        rating: String,
        review: String,
        distance: String
    ) {
        self.storeID = storeID
        self.storeName = storeName
        self.imageUrls = imageUrls
        self.picchelinStatus = picchelinStatus
        self.likeStatus = likeStatus
        self.address = address
        self.parkingInfo = parkingInfo
        self.time = time
        self.rating = rating
        self.review = review
        self.distance = distance
    }
}

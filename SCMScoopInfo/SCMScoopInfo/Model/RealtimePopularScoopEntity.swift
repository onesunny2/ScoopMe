//
//  RealtimePopularScoopEntity.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/20/25.
//

import SwiftUI

public struct RealtimePopularScoopEntity: Hashable {
    let storeID: String
    let storeName: String
    let storeImage: [String]
    let likeStatus: Bool
    let picchelinStatus: Bool
    let likeCount: String
    let distance: String
    let orderCount: String
}

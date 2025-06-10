//
//  GeolocationPost.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 6/5/25.
//

import Foundation

public struct GeolocationPost {
    public let category: String?
    public let latitude: String
    public let longitude: String
    public let maxDistance: String
    public let limit: Int
    public let next: String?
    public let orderBy: TimelineFilter
    
    public init(
        category: String? = nil,
        latitude: String,
        longitude: String,
        maxDistance: String = "300",
        limit: Int = 7,
        next: String? = nil,
        orderBy: TimelineFilter = .최신순
    ) {
        self.category = category
        self.latitude = latitude
        self.longitude = longitude
        self.maxDistance = maxDistance
        self.limit = limit
        self.next = next
        self.orderBy = orderBy
    }
}

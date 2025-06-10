//
//  PostContent.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 6/3/25.
//

import Foundation

public struct PostContent {
    public let categoty: String
    public let title: String
    public let content: String
    public let storeID: String
    public let latitude: Double
    public let longitude: Double
    public let files: [String]?
    
    public init(
        categoty: String,
        title: String,
        content: String,
        storeID: String,
        latitude: Double,
        longitude: Double,
        files: [String]?
    ) {
        self.categoty = categoty
        self.title = title
        self.content = content
        self.storeID = storeID
        self.latitude = latitude
        self.longitude = longitude
        self.files = files
    }
}

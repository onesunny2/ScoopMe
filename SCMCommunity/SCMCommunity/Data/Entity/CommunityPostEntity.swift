//
//  CommunityPostEntity.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 5/30/25.
//

import Foundation

public struct CommunityPostEntity: Hashable {
    public let creator: Creator
    public let postID: String
    public let postTitle: String
    public let postContent: String
    public let distance: Int
    public var likeCount: Int
    public var likeStatus: Bool
    public let mediaFiles: [String]?
    public let uploadTime: String
    public let storeInfo: StoreInfo
}

public struct Creator: Hashable {
    public let id: String
    public let nickname: String
    public let profileImage: String
}

public struct StoreInfo: Hashable {
    public let id: String
    public let category: String
    public let name: String
    public let image: String
    public let address: String
}

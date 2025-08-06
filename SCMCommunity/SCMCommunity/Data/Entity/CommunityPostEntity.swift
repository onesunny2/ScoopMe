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
    public var postTitle: String
    public var postContent: String
    public let distance: Int
    public var likeCount: Int
    public var likeStatus: Bool
    public let mediaFiles: [String]?
    public let uploadTime: String
    public let storeInfo: StoreInfo
    
    public init(
        creator: Creator,
        postID: String,
        postTitle: String,
        postContent: String,
        distance: Int,
        likeCount: Int,
        likeStatus: Bool,
        mediaFiles: [String]?,
        uploadTime: String,
        storeInfo: StoreInfo
    ) {
        self.creator = creator
        self.postID = postID
        self.postTitle = postTitle
        self.postContent = postContent
        self.distance = distance
        self.likeCount = likeCount
        self.likeStatus = likeStatus
        self.mediaFiles = mediaFiles
        self.uploadTime = uploadTime
        self.storeInfo = storeInfo
    }
}

public struct Creator: Hashable {
    public let id: String
    public let nickname: String
    public let profileImage: String
    
    public init(id: String, nickname: String, profileImage: String) {
        self.id = id
        self.nickname = nickname
        self.profileImage = profileImage
    }
}

public struct StoreInfo: Hashable {
    public let id: String
    public let category: String
    public let name: String
    public let image: String
    public let address: String
    
    public init(id: String, category: String, name: String, image: String, address: String) {
        self.id = id
        self.category = category
        self.name = name
        self.image = image
        self.address = address
    }
}

//
//  ChatListItemEntity.swift
//  SCMChat
//
//  Created by Lee Wonsun on 6/25/25.
//

import Foundation

public struct ChatListItemEntity {
    public let userID: String
    public let roomID: String
    public let profileImage: String
    public let username: String
    public let recentMessage: String
    public let recentTime: String
    public let messageCount: Int?
}

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
    public let profileImageURL: String
    public let username: String
    public let recentMessage: String
    public let recentTime: String
    public let messageCount: Int?
    public let messageCountString: String
    
    public init(
        userID: String,
        roomID: String,
        profileImageURL: String,
        username: String,
        recentMessage: String,
        recentTime: String,
        messageCount: Int?
    ) {
        self.userID = userID
        self.roomID = roomID
        self.profileImageURL = profileImageURL
        self.username = username
        self.recentMessage = recentMessage
        self.recentTime = recentTime
        self.messageCount = messageCount
        
        guard let messageCount else {
            self.messageCountString = ""
            return
        }
        
        self.messageCountString = "\(messageCount)"
    }
}

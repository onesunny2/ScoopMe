//
//  ChatListItemEntity.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/16/25.
//

import Foundation

struct ChatListItemEntity {
    let userID: String
    let roomID: String
    let profileImageURL: String
    let username: String
    let recentMessage: String
    let recentTime: String
    let messageCount: Int?
    let messageCountString: String
    
    init(
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

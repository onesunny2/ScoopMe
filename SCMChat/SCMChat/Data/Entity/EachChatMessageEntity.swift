//
//  EachChatMessageEntity.swift
//  SCMChat
//
//  Created by Lee Wonsun on 6/29/25.
//

import Foundation

public struct EachChatMessageEntity {
    public let chatID: String
    public let sender: MessageSender
    public let senderInfo: SenderInfo?
    public let content: String
    public let files: [String]
    public let sendDate: Date
    public let sendDateString: String
    
    public init(
        chatID: String,
        sender: MessageSender,
        senderInfo: SenderInfo?,
        content: String,
        files: [String],
        sendDate: Date,
        sendDateString: String
    ) {
        self.chatID = chatID
        self.sender = sender
        self.senderInfo = senderInfo
        self.content = content
        self.files = files
        self.sendDate = sendDate
        self.sendDateString = sendDateString
    }
}

public enum MessageSender {
    case me
    case opponent
}

public struct SenderInfo {
    public let userID: String
    public let nickname: String
    public let profileURL: String?
    
    public init(
        userID: String,
        nickname: String,
        profileURL: String?
    ) {
        self.userID = userID
        self.nickname = nickname
        self.profileURL = profileURL
    }
}

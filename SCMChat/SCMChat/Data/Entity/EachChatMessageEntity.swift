//
//  EachChatMessageEntity.swift
//  SCMChat
//
//  Created by Lee Wonsun on 6/29/25.
//

import Foundation

public struct EachChatMessageEntity: Equatable {
    public let chatID: String
    public let sender: MessageSender
    public let senderInfo: SenderInfo?
    public var sendStatus: MessageSendStatus
    public let content: String
    public let files: [String]
    public let sendDate: String
    
    public init(
        chatID: String,
        sender: MessageSender,
        senderInfo: SenderInfo?,
        sendStatus: MessageSendStatus,
        content: String,
        files: [String],
        sendDate: String
    ) {
        self.chatID = chatID
        self.sender = sender
        self.senderInfo = senderInfo
        self.sendStatus = sendStatus
        self.content = content
        self.files = files
        self.sendDate = sendDate
    }
}

public enum MessageSender {
    case me
    case opponent
}

public struct SenderInfo: Equatable {
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

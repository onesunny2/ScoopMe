//
//  EachChatMessageEntity.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/16/25.
//

import Foundation

struct EachChatMessageEntity: Equatable {
    let chatID: String
    let sender: MessageSender
    let senderInfo: SenderInfo?
    var sendStatus: MessageSendStatus
    let content: String
    let files: [String]
    let sendDate: String
    
    init(
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

enum MessageSender {
    case me
    case opponent
}

struct SenderInfo: Equatable {
    let userID: String
    let nickname: String
    let profileURL: String?
    
    init(
        userID: String,
        nickname: String,
        profileURL: String?
    ) {
        self.userID = userID
        self.nickname = nickname
        self.profileURL = profileURL
    }
}

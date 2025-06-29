//
//  ChatRoomEntity.swift
//  SCMChat
//
//  Created by Lee Wonsun on 6/29/25.
//

import Foundation

public struct EachChatMessageEntity {
    public let chatID: String
    public let sender: String
    public let content: String
    public let files: [String]
    public let sendDate: Date
    public let sendDateString: String
    
    public init(
        chatID: String,
        sender: String,
        content: String,
        files: [String],
        sendDate: Date,
        sendDateString: String
    ) {
        self.chatID = chatID
        self.sender = sender
        self.content = content
        self.files = files
        self.sendDate = sendDate
        self.sendDateString = sendDateString
    }
}

//
//  MessageRecord.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/11/25.
//

import Foundation
import RealmSwift

final class MessageRecord: Object {
    @Persisted(primaryKey: true) var chatID: String
    @Persisted var isMine: Bool
    @Persisted var content: String
    @Persisted var sendStatus: String
    @Persisted var messageType: String
    @Persisted var createdAt: String
//    @Persisted var readStatus: ReadStatus
    @Persisted var mediaType: MediaType?
    
    convenience init(
        chatID: String,
        isMine: Bool,
        content: String,
        sendStatus: String,
        messageType: String,
        createdAt: String,
//        readStatus: ReadStatus,
        mediaType: MediaType?
    ) {
        self.init()
        self.chatID = chatID
        self.isMine = isMine
        self.content = content
        self.sendStatus = sendStatus
        self.messageType = messageType
        self.createdAt = createdAt
//        self.readStatus = readStatus
    }
}

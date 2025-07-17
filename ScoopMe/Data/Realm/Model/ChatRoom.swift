//
//  ChatMessage.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/10/25.
//

import Foundation
import RealmSwift

final class ChatRoom: Object, Identifiable {
    @Persisted(primaryKey: true) var roomID: String
    @Persisted var createdAt: String
    @Persisted var participant = List<Participant>()
    @Persisted var lastMessageAt: String
    @Persisted var lastMessageContent: String
    @Persisted var isActive: Bool
    @Persisted var messages = List<MessageRecord>()
    @Persisted var unreadCount: Int?
    
    convenience init(
        roomID: String,
        createdAt: String,
        participant: List<Participant> = List<Participant>(),
        lastMessageAt: String,
        lastMessageContent: String,
        isActive: Bool,
        messages: List<MessageRecord> = List<MessageRecord>(),
        unreadCount: Int?
    ) {
        self.init()
        self.roomID = roomID
        self.createdAt = createdAt
        self.participant = participant
        self.lastMessageAt = lastMessageAt
        self.lastMessageContent = lastMessageContent
        self.isActive = isActive
        self.messages = messages
        self.unreadCount = unreadCount
    }
}

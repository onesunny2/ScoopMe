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
    @Persisted var mainUser: MainUser?
    @Persisted var participant: Participant?
    @Persisted var lastMessageAt: String
    @Persisted var lastMessageContent: String
    @Persisted var isActive: Bool
    @Persisted var messages: List<MessageRecord>
    @Persisted var unreadCount: Int?
    
    convenience init(
        roomID: String,
        createdAt: String,
        mainUser: MainUser?,
        participant: Participant?,
        lastMessageAt: String,
        lastMessageContent: String,
        isActive: Bool,
        messages: List<MessageRecord>,
        unreadCount: Int?
    ) {
        self.init()
        self.roomID = roomID
        self.createdAt = createdAt
        self.mainUser = mainUser
        self.participant = participant
        self.lastMessageAt = lastMessageAt
        self.lastMessageContent = lastMessageContent
        self.isActive = isActive
        self.messages = messages
        self.unreadCount = unreadCount
    }
}

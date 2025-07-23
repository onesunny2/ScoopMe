//
//  SCMDataSource.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/15/25.
//

import Foundation
import RealmSwift

protocol SCMDataSource: AnyObject {
    
    func create(chatRoom: ChatRoom) throws
    func fetchChatRoom(roomID: String) throws -> ChatRoom
    func fetchAllChatRooms() -> Results<ChatRoom>
    func save(roomID: String, _ message: MessageRecord) throws
    func updateMessageLastValues(roomID: String, lastMessageAt: String, lastMessageContent: String, isBoth: Bool) throws
    func updateMainuser(roomID: String, user: MainUser) throws
    func updateParticipant(roomID: String, participant: Participant) throws
    func updateChatroomActiveStatus(roomID: String, isActive: Bool) throws
    func updateMessageStatus(roomID: String, chatID: String, status: String) throws
    func replaceMessage(roomID: String, tempID: String, newMessage: MessageRecord) throws
    func deleteMessage(roomID: String, chatID: String) throws
    func deleteAllData() throws
    func markAsRead(roomID: String) throws
}

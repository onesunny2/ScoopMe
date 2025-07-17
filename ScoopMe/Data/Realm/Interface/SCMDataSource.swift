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
    func fetch(roomID: String) throws -> ChatRoom
    func fetchAllChatRooms() -> Results<ChatRoom>
    func save(roomID: String, _ message: MessageRecord) throws
    func delete(roomID: String, chatID: String, _ message: MessageRecord) throws
    func deleteAllData() throws
    func markAsRead(roomID: String) throws
}

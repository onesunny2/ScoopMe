//
//  ChatDBRepository.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/15/25.
//

import Foundation
import RealmSwift

final class ChatDBRepository: SCMDataSource {
    
    private let realm: Realm
    
    init() throws {
        realm = try Realm()
    }
    
    func create(chatRoom: ChatRoom) throws {
        let newRoom = chatRoom
        
        try realm.write {
            realm.add(newRoom)
        }
    }
    
    func fetch(roomID: String) throws -> ChatRoom {
        guard let chatRoom = realm.object(ofType: ChatRoom.self, forPrimaryKey: roomID) else {
            throw SCMRealmError.roomNotFound
        }
        
        return chatRoom
    }
    
    func save(roomID: String, _ message: MessageRecord) throws {
        let chatRoom = try fetch(roomID: roomID)
        
        try realm.write {
            chatRoom.messages.append(message)
            
            // chatRoom의 최신 메시지 정보 업데이트 필요
            chatRoom.lastMessageAt = message.createdAt
            chatRoom.lastMessageContent = message.content
        }
    }
    
    func delete(roomID: String, chatID: String, _ message: MessageRecord) throws {
        let chatRoom = try fetch(roomID: roomID)
        
        guard let index = chatRoom.messages.firstIndex(where: { $0.chatID == chatID }) else {
            throw SCMRealmError.cannotDeleteMessage
        }
        
        try realm.write {
            chatRoom.messages.remove(at: index)
        }
    }
}

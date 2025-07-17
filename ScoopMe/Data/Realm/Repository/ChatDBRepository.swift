//
//  ChatDBRepository.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/15/25.
//

import Foundation
import RealmSwift
import SCMLogger

final class ChatDBRepository: SCMDataSource {
    
    static let shared = ChatDBRepository()
    
    private let realm: Realm
    
    private init() {
        do {
            // 개발 중에는 기존 데이터 삭제하고 새로 시작
            var config = Realm.Configuration.defaultConfiguration
            config.deleteRealmIfMigrationNeeded = true  // 🔥 개발용
            
            self.realm = try Realm(configuration: config)
            Log.debug("✅ Realm 초기화 성공")
        } catch {
            Log.error("❌ Realm 초기화 실패: \(error)")
            fatalError("Realm 초기화 실패: \(error)")
        }
    }
    
    func create(chatRoom: ChatRoom) throws {
        let newRoom = chatRoom
        
        try realm.write {
            realm.add(newRoom, update: .modified)
        }
    }
    
    func fetch(roomID: String) throws -> ChatRoom {
        guard let chatRoom = realm.object(ofType: ChatRoom.self, forPrimaryKey: roomID) else {
            throw SCMRealmError.roomNotFound
        }
        
        return chatRoom
    }
    
    func fetchAllChatRooms() -> Results<ChatRoom> {
        return realm.objects(ChatRoom.self)
            .sorted(byKeyPath: "lastMessageAt", ascending: false)
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
    
    func deleteAllData() throws {
        try realm.write {
            realm.deleteAll()
        }
    }
    
    // 채팅방 읽음처리
    func markAsRead(roomID: String) throws {
        let chatRoom = try fetch(roomID: roomID)
        
        try realm.write {
            chatRoom.unreadCount = 0
        }
    }
}

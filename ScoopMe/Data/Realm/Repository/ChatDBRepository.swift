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
    
    private let realm = try! Realm()
    
    private init() {
//        // 개발 중에는 기존 데이터 삭제하고 새로 시작
//        var config = Realm.Configuration.defaultConfiguration
//        //            config.deleteRealmIfMigrationNeeded = true  // 🔥 개발용
//        
//        if let fileURL = config.fileURL {
//            Log.debug("✅ Realm 파일 경로: \(fileURL.path)")
//        } else {
//            Log.debug("❌ Realm 파일 경로를 찾을 수 없음")
//        }
    }
    
    func create(chatRoom: ChatRoom) throws {
        let newRoom = chatRoom
        
        try realm.write {
            realm.add(newRoom, update: .modified)
        }
    }
    
    func fetchChatRoom(roomID: String) throws -> ChatRoom {
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

        let chatRoom = try fetchChatRoom(roomID: roomID)

        try realm.write {
            // 메시지가 realm에 아직 등록되지 않았다면 추가
            if message.realm == nil {
                realm.add(message, update: .modified)
            }

            // 중복 방지: 같은 chatID가 이미 포함되어 있는지 확인
            if !chatRoom.messages.contains(where: { $0.chatID == message.chatID }) {
                chatRoom.messages.append(message)
            } else {
                Log.debug("⚠️ 중복된 메시지를 append 시도함: \(message.chatID)")
            }

            chatRoom.lastMessageAt = message.createdAt
            chatRoom.lastMessageContent = message.content
        }

//        Log.debug("✅ 메시지 저장 완료: \(message.chatID), 현재 메시지 수: \(chatRoom.messages.count)")
    }
    
    func updateMessageLastValues(roomID: String, lastMessageAt: String, lastMessageContent: String, isBoth: Bool) throws {
        let chatRoom = try fetchChatRoom(roomID: roomID)
        
        try realm.write {
            chatRoom.lastMessageAt = lastMessageAt
            if isBoth { chatRoom.lastMessageContent = lastMessageContent }
        }
    }
    
    func updateMainuser(roomID: String, user: MainUser) throws {
        let chatRoom = try fetchChatRoom(roomID: roomID)
        
        try realm.write {
            chatRoom.mainUser = user
        }
    }
    
    func updateParticipant(roomID: String, participant: Participant) throws {
        let chatRoom = try fetchChatRoom(roomID: roomID)
        
        try realm.write {
            chatRoom.participant = participant
        }
    }
    
    func updateChatroomActiveStatus(roomID: String, isActive: Bool) throws {
        let chatRoom = try fetchChatRoom(roomID: roomID)
        
        try realm.write {
            chatRoom.isActive = isActive
        }
    }
    
    func updateMessageStatus(roomID: String, chatID: String, status: String) throws {
        try realm.write {
            if let chatRoom = realm.object(ofType: ChatRoom.self, forPrimaryKey: roomID), let message = chatRoom.messages.first(where: { $0.chatID == chatID}) {
                message.sendStatus = status
            }
        }
    }
    
    // 임시 메시지를 정식으로 서버 메시지로 교체
    func replaceMessage(roomID: String, tempID: String, newMessage: MessageRecord) throws {
        try realm.write {
            guard let chatRoom = realm.object(ofType: ChatRoom.self, forPrimaryKey: roomID) else { return }
            
            if let tempMessage = chatRoom.messages.first(where: { $0.chatID == tempID }), let index = chatRoom.messages.firstIndex(of: tempMessage) {
                chatRoom.messages.remove(at: index)
                realm.delete(tempMessage)
            }
            
            realm.add(newMessage, update: .modified)
            
            chatRoom.messages.append(newMessage)
            chatRoom.lastMessageAt = newMessage.createdAt
            chatRoom.lastMessageContent = newMessage.content
        }
    }
    
    func deleteMessage(roomID: String, chatID: String, _ message: MessageRecord) throws {
        let chatRoom = try fetchChatRoom(roomID: roomID)
        
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
        let chatRoom = try fetchChatRoom(roomID: roomID)
        
        try realm.write {
            chatRoom.unreadCount = 0
        }
    }
}

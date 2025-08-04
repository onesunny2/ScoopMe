//
//  ChatRoomTracker.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 8/1/25.
//

import Foundation

final class ChatRoomTracker: ChatRoomTrackService, ObservableObject {
    
    static let shared = ChatRoomTracker()
    
    @Published private var currentRoomID: String?
    @Published private var isAppActive: Bool = true
    
    private init() { }
    
    func enterChatRoom(room id: String) {
        currentRoomID = id
    }
    
    func leaveChatRoom() {
        currentRoomID = nil
    }
    
    func getCurrentRoomID() -> String? {
        return currentRoomID
    }
    
    func isInChatRoom(room id: String) -> Bool {
        return isAppActive && (currentRoomID == id)
    }
    
    func updateAppState(_ isActive: Bool) {
        isAppActive = isActive
    }
}

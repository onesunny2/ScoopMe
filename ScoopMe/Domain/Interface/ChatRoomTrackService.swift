//
//  ChatRoomTrackService.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 8/1/25.
//

import Foundation

protocol ChatRoomTrackService: AnyObject {
    func enterChatRoom(room id: String)
    func leaveChatRoom()
    func getCurrentRoomID() -> String?
    func isInChatRoom(room id: String) -> Bool
    func updateAppState(_ isActive: Bool)
}

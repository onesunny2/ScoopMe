//
//  ChatRoomDisplayable.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/16/25.
//

import Foundation

protocol ChatRoomDisplayable: ChatNetworkProvider {
    func fetchChatRoom(roomID: String) -> ChatRoom?
    func getChatMessages(roomID: String, messageInfo: GetMessages) async throws
    func saveTempMessage(roomID: String, message: MessageRecord) async throws
    func updateMessageStatus(roomID: String, chatID: String, status: String) async throws
    func postNewMessage(roomID: String, messageInfo: PostMessages, temptID: String) async throws
}

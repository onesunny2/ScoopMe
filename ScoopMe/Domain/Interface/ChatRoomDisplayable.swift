//
//  ChatRoomDisplayable.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/16/25.
//

import Foundation

protocol ChatRoomDisplayable: ChatNetworkProvider {
    func getChatMessages(messageInfo: GetMessages) async throws -> [EachChatMessageEntity]
    func postNewMessage(messageInfo: PostMessages) async throws -> EachChatMessageEntity
}

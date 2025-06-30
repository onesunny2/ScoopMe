//
//  ChatRoomDisplayable.swift
//  SCMChat
//
//  Created by Lee Wonsun on 6/30/25.
//

import Foundation

public protocol ChatRoomDisplayable: ChatNetworkProvider {
    func getChatMessages() async throws -> [EachChatMessageEntity]
}

//
//  ChatListDisplayable.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/16/25.
//

import Foundation

protocol ChatListDisplayable: ChatNetworkProvider {
    
    func getChatroomID(opponent id: String) async throws -> String
    func getChatLists() async throws -> [ChatListItemEntity]
}

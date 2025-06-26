//
//  ChatListDisplayable.swift
//  SCMChat
//
//  Created by Lee Wonsun on 6/26/25.
//

import Foundation

public protocol ChatListDisplayable: ChatNetworkProvider {
    
    func getChatLists() async throws -> [ChatListItemEntity]
}

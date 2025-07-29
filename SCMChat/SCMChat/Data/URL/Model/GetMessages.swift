//
//  GetMessages.swift
//  SCMChat
//
//  Created by Lee Wonsun on 7/9/25.
//

import Foundation

public struct GetMessages {
    public let roomID: String
    public let lastMessageDate: String
    
    public init(roomID: String, lastMessageDate: String) {
        self.roomID = roomID
        self.lastMessageDate = lastMessageDate
    }
}

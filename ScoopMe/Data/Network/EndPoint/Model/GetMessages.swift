//
//  GetMessages.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/16/25.
//

import Foundation

struct GetMessages {
    let roomID: String
    let lastMessageDate: String
    
    init(roomID: String, lastMessageDate: String) {
        self.roomID = roomID
        self.lastMessageDate = lastMessageDate
    }
}

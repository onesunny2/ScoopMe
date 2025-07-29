//
//  PostMessages.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/16/25.
//

import Foundation

struct PostMessages {
    let roomID: String
    let contents: String
    let files: [String?]
    
    init(roomID: String, contents: String, files: [String?]) {
        self.roomID = roomID
        self.contents = contents
        self.files = files
    }
}

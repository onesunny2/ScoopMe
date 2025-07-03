//
//  PostMessages.swift
//  SCMChat
//
//  Created by Lee Wonsun on 7/1/25.
//

import Foundation

public struct PostMessages {
    public let roomID: String
    public let contents: String
    public let files: [String?]
    
    public init(roomID: String, contents: String, files: [String?]) {
        self.roomID = roomID
        self.contents = contents
        self.files = files
    }
}

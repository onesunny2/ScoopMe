//
//  PostComment.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 8/6/25.
//

import Foundation

public struct PostComment {
    let parentID: String?
    let content: String
    
    public init(
        parentID: String?,
        content: String
    ) {
        self.parentID = parentID
        self.content = content
    }
}

//
//  CommentInfo.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 8/7/25.
//

import Foundation

public struct CommentInfo {
    public let postID: String
    public let commentID: String
    public let content: String?
    
    public init(
        postID: String,
        commentID: String,
        content: String?
    ) {
        self.postID = postID
        self.commentID = commentID
        self.content = content
    }
}

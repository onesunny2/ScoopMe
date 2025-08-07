//
//  PostCommentView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 8/6/25.
//

import SwiftUI
import SCMCommunity

struct PostCommentView: View {
    
    private var comments: [CommentResponseDTO]
    
    init(comments: [CommentResponseDTO]) {
        self.comments = comments
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

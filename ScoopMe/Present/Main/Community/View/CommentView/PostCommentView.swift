//
//  PostCommentView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 8/6/25.
//

import SwiftUI
import SCMCommunity
import SCMImageRequest

struct PostCommentView: View {
    
    private let imageHelper: ImageHelper
    private var comments: [CommentResponseDTO]
    
    @FocusState private var focusBinding
    
    @State private var commentText: String = ""
    @State private var isEditing: Bool = false
    @State private var sendStatus: Bool = false
    
    init(
        imageHelper: ImageHelper,
        comments: [CommentResponseDTO]
    ) {
        self.imageHelper = imageHelper
        self.comments = comments
    }
    
    var body: some View {
        VStack(alignment: .center) {
            contentView
            
            if !isEditing {
                CommentInputView(
                    textMessage: $commentText,
                    sendStatus: $sendStatus,
                    focusBinding: $focusBinding
                )
                .defaultHorizontalPadding()
            }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if !comments.isEmpty {
            mainComments
        } else {
            emptyView
        }
    }
    
    private var mainComments: some View {
        ScrollView(.vertical) {
            ForEach(comments, id: \.commentId) { comment in
                CommentCell(
                    imageHelper: imageHelper,
                    comment: comment,
                    canReply: true,
                    isEditing: $isEditing,
                    sendStatus: $sendStatus
                )
            }
        }
    }
    
    private var emptyView: some View {
        VStack {
            Spacer()
            Text(StringLiterals.emptyComment.string)
                .basicText(.PTBody5, .scmGray75)
            Spacer()
        }
    }
}

// MARK: StringLiterals
private enum StringLiterals: String {
    case emptyComment = "아직 등록된 댓글이 없습니다"
    
    var string: String {
        return self.rawValue
    }
}

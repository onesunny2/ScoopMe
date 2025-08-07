//
//  PostCommentView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 8/6/25.
//

import SwiftUI
import SCMCommunity
import SCMImageRequest
import SCMLogger

struct PostCommentView: View {
    
    private let commentRepository: CommentDisplayable
    private let imageHelper: ImageHelper
    @Binding var postID: String
    @Binding var comments: [CommentResponseDTO]
    
    @FocusState private var focusBinding
    
    @State private var commentText: String = ""
    @State private var isEditing: Bool = false
    
    @State private var parentID: String? = nil
    @State private var failedUpload: Bool = false
    
    init(
        commentRepository: CommentDisplayable,
        imageHelper: ImageHelper,
        postID: Binding<String>,
        comments: Binding<[CommentResponseDTO]>
    ) {
        self.commentRepository = commentRepository
        self.imageHelper = imageHelper
        self._postID = postID
        self._comments = comments
    }
    
    var body: some View {
        VStack(alignment: .center) {
            contentView
            
            inputCommentView
        }
        .showAlert(
            isPresented: $failedUpload,
            title: StringLiterals.uploadFailedTitle.string,
            message: StringLiterals.uploadFailedMessage.string,
            buttonTitle: StringLiterals.uploadFailedButton.string
        ) {
            // 업로드 재시도
            Task {
                let content = PostComment(
                    parentID: parentID,
                    content: commentText
                )
                await postNewComment(postID: postID, content: content)
            }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if !comments.isEmpty {
            mainComments
                .defaultHorizontalPadding()
                .padding(.top, 20)
        } else {
            emptyView
        }
    }
    
    private var mainComments: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(comments, id: \.commentId) { comment in
                CommentCell(
                    imageHelper: imageHelper,
                    comment: comment,
                    canReply: true
                ) {
                    isEditing = true
                }
                .padding(.vertical, 10)
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
    
    @ViewBuilder
    private var inputCommentView: some View {
        if !isEditing {
            CommentInputView(
                textMessage: $commentText,
                focusBinding: $focusBinding,
                parentID: parentID
            ) { comment in
                parentID = nil
                
                Task {
                    commentText = ""
                    await postNewComment(postID: postID, content: comment)
                }
            }
            .defaultHorizontalPadding()
        }
    }
}

// MARK: Action
extension PostCommentView {
    // 새 댓글 등록
    private func postNewComment(
        postID: String,
        content: PostComment
    ) async {
        do {
            let uploadedComment = try await commentRepository.postComment(postID: postID, content: content)
            comments.append(uploadedComment)
        } catch {
            Log.error("❌ 새 댓글 등록 실패: \(error)")
            failedUpload = true
        }
    }
}

// MARK: StringLiterals
private enum StringLiterals: String {
    case emptyComment = "아직 등록된 댓글이 없습니다"
    case uploadFailedTitle = "실패"
    case uploadFailedMessage = "댓글 등록에 실패했습니다"
    case uploadFailedButton = "재시도"
    
    var string: String {
        return self.rawValue
    }
}

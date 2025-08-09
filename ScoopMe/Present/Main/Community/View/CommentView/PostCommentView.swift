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
    @State private var isReplying: Bool = false
    
    @State private var parentID: String? = nil
    @State private var failedUpload: Bool = false
    @State private var failedDelete: Bool = false
    @State private var failedEdit: Bool = false
    @State private var willEditComment: CommentInfo? = nil
    @State private var isDeleted: Bool = false
    @State private var willDeleteComment: CommentInfo? = nil
    
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
        VStack(alignment: .center, spacing: 0) {
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
        .showAlert(
            isPresented: $failedEdit,
            title: StringLiterals.uploadFailedTitle.string,
            message: StringLiterals.editFailedMessage.string,
            buttonTitle: StringLiterals.uploadFailedButton.string
        ) {
            // 댓글 수정 재시도
            Task {
                guard let comment = willEditComment else { return }
                await editComment(comment: comment)
                isEditing = false
            }
        }
        .showAlert(
            isPresented: $isDeleted,
            title: StringLiterals.deleteTitle.string,
            message: StringLiterals.deleteMessage.string,
            buttonTitle: nil) {
                Task {
                    guard let comment = willDeleteComment else { return }
                    await deleteComment(comment: comment)
                }
            }
            .showAlert(
                isPresented: $failedDelete,
                title: StringLiterals.deleteFailedTitle.string,
                message: StringLiterals.deleteFailedMessage.string
            )
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
            ForEach($comments, id: \.commentId) { comment in
                CommentCell(
                    imageHelper: imageHelper,
                    postID: $postID,
                    comment: comment,
                    canReply: true,
                    tappedEdit: {
                        isEditing.toggle()
                    },
                    sendEditComment: { info in
                        Task {
                            willEditComment = info
                            await editComment( comment: info)
                            isEditing = false
                        }
                    },
                    tappedDelete: { info in
                        willDeleteComment = info
                        isDeleted = true
                    },
                    tappedReply: { replyStatus in
                        isReplying = replyStatus
                        parentID = isReplying ? comment.wrappedValue.commentId : nil
                    }
                )
                .padding(.top, 10)
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
        if !isEditing && !isReplying {
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
            .background(.scmGray45)
            .ignoresSafeArea(.container, edges: .bottom)
        } else if !isEditing && isReplying {
            VStack {
                Text("현재 대댓글 작성 중 입니다")
                    .basicText(.PTBody4, .scmDeepSprout)
                
                CommentInputView(
                    textMessage: $commentText,
                    focusBinding: $focusBinding,
                    parentID: parentID
                ) { comment in
                    Task {
                        commentText = ""
                        await postNewComment(postID: postID, content: comment)
                    }
                }
                .defaultHorizontalPadding()
                .background(.scmGray45)
                .ignoresSafeArea(.container, edges: .bottom)
            }
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
            
            if !isReplying {
                comments.append(uploadedComment)
            } else {
                let reply = ReplyDTO(
                    commentId: uploadedComment.commentId,
                    content: uploadedComment.content,
                    createdAt: uploadedComment.createdAt,
                    creator: uploadedComment.creator
                )
                let parentID = content.parentID
                
                guard let index = comments.firstIndex(where: { $0.commentId == parentID }) else { return }
                comments[index].replies?.append(reply)
                
                isReplying = false
            }
        } catch {
            Log.error("❌ 새 댓글 등록 실패: \(error)")
            failedUpload = true
        }
    }
    
    // 댓글 수정
    private func editComment(comment: CommentInfo) async {
        do {
            let editedComment = try await commentRepository.editComment(comment: comment)
            
            guard let index = comments.firstIndex(where: { $0.commentId == comment.commentID }) else { return }
            
            comments[index] = editedComment
            isEditing = false
        } catch {
            Log.error("❌ 댓글 수정 실패: \(error)")
            failedEdit = true
        }
    }
    
    // 댓글 삭제
    private func deleteComment(comment: CommentInfo) async {
        do {
            try await commentRepository.deleteComment(comment: comment)
            
            guard let index = comments.firstIndex(where: { $0.commentId == comment.commentID }) else { return }
            
            comments.remove(at: index)
            
        } catch {
            Log.error("❌ 댓글 삭제 실패: \(error)")
            failedDelete = true
        }
    }
}

// MARK: StringLiterals
private enum StringLiterals: String {
    case emptyComment = "아직 등록된 댓글이 없습니다"
    case uploadFailedTitle = "등록 실패"
    case uploadFailedMessage = "댓글 등록에 실패했습니다"
    case uploadFailedButton = "재시도"
    case editFailedMessage = "댓글 수정에 실패했습니다"
    case deleteTitle = "삭제"
    case deleteMessage = "이 댓글을 삭제하시겠습니까?"
    case deleteFailedTitle = "삭제 실패"
    case deleteFailedMessage = "댓글 삭제에 실패했습니다"
    
    var string: String {
        return self.rawValue
    }
}

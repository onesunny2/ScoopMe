//
//  ReplyCommentCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 8/8/25.
//

import SwiftUI
import SCMCommunity
import SCMImageRequest
import SCMLogger

struct ReplyCommentCell: View {
    
    @State private var editingText: String = ""
    @FocusState private var focusBinding: Bool
    
    @State private var failedDelete: Bool = false
    @State private var failedEdit: Bool = false
    @State private var willEditComment: CommentInfo? = nil
    @State private var isDeleted: Bool = false
    @State private var willDeleteComment: CommentInfo? = nil
    
    private let commentRepository: CommentDisplayable
    private let imageHelper: ImageHelper
    @Binding var postID: String
    private let parentID: String
    private var reply: ReplyDTO
    private var sendEditedReply: ((ReplyDTO) -> Void)?
    private var completeDeleted: (() -> Void)?
    
    @State private var isEditing: Bool = false
    
    private let profileSize: CGFloat = 50
    
    init(
        commentRepository: CommentDisplayable,
        imageHelper: ImageHelper,
        postID: Binding<String>,
        parentID: String,
        reply: ReplyDTO,
        sendEditedReply: ((ReplyDTO) -> Void)?,
        completeDeleted: (() -> Void)?
    ) {
        self.commentRepository = commentRepository
        self.imageHelper = imageHelper
        self._postID = postID
        self.parentID = parentID
        self.reply = reply
        self.sendEditedReply = sendEditedReply
        self.completeDeleted = completeDeleted
    }
    
    var body: some View {
        commentView
            .showAlert(
                isPresented: $failedEdit,
                title: StringLiterals.editFailedTitle.string,
                message: StringLiterals.editFailedMessage.string,
                buttonTitle: StringLiterals.editFailedButton.string
            ) {
                // 댓글 수정 재시도
                Task {
                    guard let comment = willEditComment else { return }
                    await editReply(comment: comment)
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
    
    private var commentView: some View {
        HStack(alignment: .top, spacing: 6) {
            profileImage
            
            VStack(alignment: .leading, spacing: isEditing ? 8 : 16) {
                commentInfo
                commentButtons
            }
        }
    }
    
    private var profileImage: some View {
        NukeRequestImageCell(
            imageHelper: imageHelper,
            url: reply.creator.profileImage ?? "",
            topLeading: profileSize / 2,
            bottomLeading: profileSize / 2,
            bottomTrailing: profileSize / 2,
            topTrailing: profileSize / 2
        )
        .frame(width: profileSize, height: profileSize)
    }
    
    private var commentInfo: some View {
        VStack(alignment: .leading, spacing: isEditing ? 0 : 8) {
            HStack(alignment: .center, spacing: 4) {
                Text(reply.creator.nick)
                    .basicText(.PTTitle3, .scmGray100)
                Text(reply.createdAt.toRelativeTime())
                    .basicText(.PTTitle5, .scmGray60)
            }
            
            commentText
        }
    }
    
    @ViewBuilder
    private var commentText: some View {
        if !isEditing {
            Text(reply.content)
                .basicText(.PTTitle5, .scmGray100)
        }
        
        if isEditing {
            CommentInputView(
                textMessage: $editingText,
                focusBinding: $focusBinding,
                sendEditComment:  {
                    // 수정된 댓글 정보 보내기
                    let editedComment = ReplyDTO(
                        commentId: reply.commentId,
                        content: editingText,
                        createdAt: reply.createdAt,
                        creator: reply.creator
                    )
                    
                    sendEditedReply?(editedComment)
                    
                    Task {
                        try? await Task.sleep(for: .seconds(0.3))
                        isEditing = false
                    }
                    
                })
        }
    }
    
    private var commentButtons: some View {
        HStack(alignment: .center, spacing: 10) {
            if isEditing {
                Text(StringLiterals.cancelReply.string)
                    .basicText(.PTTitle6, .scmGray90)
                    .asButton {
                        Log.debug("🔗 수정취소 탭탭")
                        isEditing = false
                    }
            }
            
            Spacer()
            
            if !isEditing {
                Text(StringLiterals.edit.string)
                    .basicText(.PTTitle6, .scmBlackSprout)
                    .asButton {
                        Log.debug("🔗 수정 탭탭")
                        isEditing = true
                        editingText = reply.content
                    }
                
                Text(StringLiterals.delete.string)
                    .basicText(.PTTitle6, .scmBlackSprout)
                    .asButton {
                        Log.debug("🔗 삭제 탭탭")
                        Task {
                            let info = CommentInfo(
                                postID: postID,
                                commentID: reply.commentId,
                                content: reply.content
                            )
                            await deleteComment(comment: info)
                        }
                    }
            }
        }
    }
}

// MARK: Action
extension ReplyCommentCell {
    // 대댓글 수정
    private func editReply(comment: CommentInfo) async {
        do {
            let comment = try await commentRepository.editComment(comment: comment)
            
            let reply = ReplyDTO(
                commentId: comment.commentId,
                content: comment.content,
                createdAt: comment.createdAt,
                creator: comment.creator
            )
            
            sendEditedReply?(reply)
        } catch {
            Log.error("❌ 대댓글 수정 실패: \(error)")
            failedEdit = true
        }
    }
    
    // 대댓글 삭제
    private func deleteComment(comment: CommentInfo) async {
        do {
            try await commentRepository.deleteComment(comment: comment)
            
            // 삭제 완료되었다는 트리거 이전 화면에 전달
            completeDeleted?()
        } catch {
            Log.error("❌ 댓글 삭제 실패: \(error)")
            failedDelete = true
        }
    }
}

// MARK: StringLiterals
private enum StringLiterals: String {
    case reply = "답글 달기"
    case edit = "수정"
    case delete = "삭제"
    case cancelReply = "수정 취소"
    case editFailedTitle = "수정 실패"
    case editFailedMessage = "댓글 수정에 실패했습니다"
    case editFailedButton = "재시도"
    case deleteTitle = "댓글 삭제"
    case deleteMessage = "이 댓글을 삭제하시겠습니까?"
    case deleteFailedTitle = "삭제 실패"
    case deleteFailedMessage = "댓글 삭제에 실패했습니다"
    
    var string: String {
        return self.rawValue
    }
}

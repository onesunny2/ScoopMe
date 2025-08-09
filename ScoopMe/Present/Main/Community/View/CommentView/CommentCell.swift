//
//  CommentCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 8/6/25.
//

import SwiftUI
import SCMCommunity
import SCMImageRequest
import SCMLogger

struct CommentCell: View {
    
    @State private var editingText: String = ""
    @FocusState private var focusBinding: Bool
    
    private let imageHelper: ImageHelper
    @Binding var postID: String
    @Binding var comment: CommentResponseDTO
    private let canReply: Bool
    private var tappedEdit: (() -> Void)?
    private var sendEditComment: ((CommentInfo) -> Void)?
    private var tappedDelete: ((CommentInfo) -> Void)?
    private var tappedReply: ((Bool) -> Void)?
    
    @State private var isEditing: Bool = false
    @State private var isReply: Bool = false
    
    private let profileSize: CGFloat = 50
    
    init(
        imageHelper: ImageHelper,
        postID: Binding<String>,
        comment: Binding<CommentResponseDTO>,
        canReply: Bool,
        tappedEdit: (() -> Void)?,
        sendEditComment: ((CommentInfo) -> Void)?,
        tappedDelete: ((CommentInfo) -> Void)?,
        tappedReply: ((Bool) -> Void)?
    ) {
        self.imageHelper = imageHelper
        self._postID = postID
        self._comment = comment
        self.canReply = canReply
        self.tappedEdit = tappedEdit
        self.sendEditComment = sendEditComment
        self.tappedDelete = tappedDelete
        self.tappedReply = tappedReply
    }
    
    var body: some View {
        contentView
    }
    
    private var contentView: some View {
        VStack(alignment: .trailing) {
            commentView
            
            // 대댓글
            if let replies = comment.replies {
                VStack(spacing: 8) {
                    ForEach(replies, id: \.commentId) { reply in
                        ReplyCommentCell(
                            commentRepository: DIContainer.shared.commentRepository,
                            imageHelper: imageHelper,
                            postID: $postID,
                            parentID: comment.commentId,
                            reply: reply,
                            sendEditedReply: { editedReply in
                                guard let replies = comment.replies, let index = replies.firstIndex(where: { $0.commentId == editedReply.commentId }) else { return }
                                
                                comment.replies?[index] = editedReply
                            },
                            completeDeleted: {
                                guard let replies = comment.replies, let index = replies.firstIndex(of: reply) else { return }
                                
                                comment.replies?.remove(at: index)
                            }
                        )
                    }
                }
                .padding(.leading, 56)
                .padding(.top, 16)
            }
        }
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
            url: comment.creator.profileImage ?? "",
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
                Text(comment.creator.nick)
                    .basicText(.PTTitle3, .scmGray100)
                Text(comment.createdAt.toRelativeTime())
                    .basicText(.PTTitle5, .scmGray60)
            }
            
            commentText
        }
    }
    
    @ViewBuilder
    private var commentText: some View {
        if !isEditing {
            Text(comment.content)
                .basicText(.PTTitle5, .scmGray100)
        }
        
        if isEditing {
            CommentInputView(
                textMessage: $editingText,
                focusBinding: $focusBinding,
                sendEditComment:  {
                    // 수정된 댓글 정보 보내기
                    let info = CommentInfo(
                        postID: postID,
                        commentID: comment.commentId,
                        content: editingText
                    )
                    sendEditComment?(info)
                    Task {
                        try? await Task.sleep(for: .seconds(0.3))
                        isEditing = false
                    }
                    
                })
        }
    }
    
    private var commentButtons: some View {
        HStack(alignment: .center, spacing: 10) {
            if canReply && !isEditing {
                Text(isReply ? StringLiterals.cancelReply.string :  StringLiterals.reply.string)
                    .basicText(.PTTitle6, isReply ? .scmBlackSprout : .scmGray90)
                    .asButton {
                        Log.debug("🔗 답글달기 탭탭")
                        isReply.toggle()
                        tappedReply?(isReply)
                    }
            } else if isEditing {
                Text(StringLiterals.cancelEdit.string)
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
                        tappedEdit?()
                        isEditing = true
                        editingText = comment.content
                    }
                
                Text(StringLiterals.delete.string)
                    .basicText(.PTTitle6, .scmBlackSprout)
                    .asButton {
                        Log.debug("🔗 삭제 탭탭")
                        let willDeleteComment = CommentInfo(
                            postID: postID,
                            commentID: comment.commentId,
                            content: nil
                        )
                        tappedDelete?(willDeleteComment)
                    }
            }
        }
    }
}

// MARK: StringLiterals
private enum StringLiterals: String {
    case reply = "답글 달기"
    case cancelReply = "답글 취소"
    case edit = "수정"
    case delete = "삭제"
    case cancelEdit = "수정 취소"
    
    var string: String {
        return self.rawValue
    }
}

#Preview {
    
    let creator = UserInfoResponseDTO(
        userId: "dfdf",
        nick: "이원선",
        profileImage: nil
    )
    
    let comment = CommentResponseDTO(
        commentId: "",
        content: "안녕하세요, 포스트 잘 보고 갑니다!",
        createdAt: "2025-07-25T09:15:00.000Z",
        creator: creator,
        replies: []
    )
    
    CommentCell(
        imageHelper: DIContainer.shared.imageHelper,
        postID: .constant(""),
        comment: .constant(comment),
        canReply: false,
        tappedEdit: nil,
        sendEditComment: nil,
        tappedDelete: nil,
        tappedReply: nil
    )
}

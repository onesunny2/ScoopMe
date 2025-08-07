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
    private let comment: CommentResponseDTO
    private let canReply: Bool
    
    @Binding var isEditing: Bool
    @Binding var sendStatus: Bool
    
    private let profileSize: CGFloat = 60
    
    init(
        imageHelper: ImageHelper,
        comment: CommentResponseDTO,
        canReply: Bool,
        isEditing: Binding<Bool>,
        sendStatus: Binding<Bool>
    ) {
        self.imageHelper = imageHelper
        self.comment = comment
        self.canReply = canReply
        self._isEditing = isEditing
        self._sendStatus = sendStatus
    }
    
    var body: some View {
        commentView
    }
    
    private var commentView: some View {
        HStack(alignment: .top, spacing: 6) {
            profileImage
            
            VStack(alignment: .leading, spacing: 16) {
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
                    .basicText(.PTTitle7, .scmGray100)
                Text(comment.createdAt.toRelativeTime())
                    .basicText(.PTBody7, .scmGray60)
            }
            
            commentText
        }
    }
    
    @ViewBuilder
    private var commentText: some View {
        if !isEditing {
            Text(comment.content)
                .basicText(.PTBody7, .scmGray100)
        }
        
        if isEditing {
            CommentInputView(
                textMessage: $editingText,
                sendStatus: $sendStatus,
                focusBinding: $focusBinding
            )
        }
    }
    
    private var commentButtons: some View {
        HStack(alignment: .center, spacing: 10) {
            if canReply {
                Text(StringLiterals.reply.string)
                    .basicText(.PTTitle6, .scmGray90)
                    .asButton {
                        Log.debug("🔗 답글달기 탭탭")
                    }
            }
            
            Spacer()
            
            if !isEditing {
                Text(StringLiterals.edit.string)
                    .basicText(.PTTitle6, .scmBlackSprout)
                    .asButton {
                        Log.debug("🔗 수정 탭탭")
                        isEditing = true
                        editingText = comment.content
                    }
                
                Text(StringLiterals.delete.string)
                    .basicText(.PTTitle6, .scmBlackSprout)
                    .asButton {
                        Log.debug("🔗 삭제 탭탭")
                    }
            }
        }
    }
}

// MARK: StringLiterals
private enum StringLiterals: String {
    case reply = "답글 달기"
    case edit = "수정"
    case delete = "삭제"
    
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
        comment: comment,
        canReply: false,
        isEditing: .constant(true),
        sendStatus: .constant(false)
    )
}

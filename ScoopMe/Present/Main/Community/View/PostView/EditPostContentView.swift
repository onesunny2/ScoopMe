//
//  EditPostContentView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 8/6/25.
//

import SwiftUI
import SCMCommunity
import SCMLogger

struct EditPostContentView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var post: CommunityPostEntity?
    @Binding var isEditCompleted: Bool
    @Binding var isEditFailed: Bool
    
    @State private var title: String = ""
    @State private var content: String = ""
    
    private var tappedSave: ((EditContent) -> Void)?
    private var tappedResave: ((EditContent) -> Void)?
    
    init(
        post: Binding<CommunityPostEntity?>,
        isEditCompleted: Binding<Bool>,
        iseditFailed: Binding<Bool>,
        tappedSave: ((EditContent) -> Void)?,
        tappedResave: ((EditContent) -> Void)?
    ) {
        self._post = post
        self._isEditCompleted = isEditCompleted
        self._isEditFailed = iseditFailed
        self.tappedSave = tappedSave
        self.tappedResave = tappedResave
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                titleView
                .padding(.bottom, 28)
                
                contentView
                    .frame(height: 300)
            }
            .defaultHorizontalPadding()
            .onAppear {
                title = post?.postTitle ?? ""
                content = post?.postContent ?? ""
            }
            .navigationTitle(StringLiterals.navigationTitle.text)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarItem { } trailing: {
                Text(StringLiterals.save.text)
                    .basicText(.PTBody5, .scmBlackSprout)
                    .asButton {
                        Log.debug("🔗 게시글 수정 저장버튼 탭탭")
                        
                        let newPost = EditContent(
                            title: title,
                            content: content
                        )
                        tappedSave?(newPost)
                    }
            }
            .showAlert(
                isPresented: $isEditCompleted,
                title: StringLiterals.completeAlertTitle.text,
                message: StringLiterals.completeAlertMessage.text
            ) {
                post?.postTitle = title
                post?.postContent = content
                dismiss()
            }
            .showAlert(
                isPresented: $isEditFailed,
                title: StringLiterals.failedAlertTitle.text,
                message: StringLiterals.failedAlertMessage.text,
                buttonTitle: StringLiterals.failedAlertButton.text) {
                    
                    Log.debug("🔗 게시글 수정 재시도 버튼 탭탭")
                    
                    let newPost = EditContent(
                        title: title,
                        content: content
                    )
                    tappedResave?(newPost)
                }
        }
    }
    
    // 제목
    private var titleView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(StringLiterals.postTitle.text)
                .basicText(.PTTitle6, .scmGray90)
            titleTextField
        }
    }
    
    private var titleTextField: some View {
        TitleTextFieldCell(
            titleText: $title,
            placeholder: StringLiterals.titlePlaceholder.text
        )
    }
    
    // 내용
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(StringLiterals.postContent.text)
                .basicText(.PTTitle6, .scmGray90)
            contentEditor
        }
    }
    
    private var contentEditor: some View {
        ContentTextEditorCell(
            contentText: $content,
            placeholder: StringLiterals.contentPlaceholder.text
        )
    }
}

// MARK: String Literals
private enum StringLiterals: String {
    case navigationTitle = "게시글 수정"
    case postTitle = "제목"
    case postContent = "포스트 내용"
    case save = "저장"
    case close = "닫기"
    case titlePlaceholder = "제목을 15자 이내로 작성해주세요."
    case contentPlaceholder = "주변 소식통에 올릴 포스트 내용을 작성해 주세요.(300자 이내)"
    case completeAlertTitle = "완료"
    case completeAlertMessage = "게시글이 정상적으로 수정되었습니다"
    case failedAlertTitle = "오류"
    case failedAlertMessage = "게시글 수정에 실패했습니다"
    case failedAlertButton = "재시도"
    
    var text: String {
        return self.rawValue
    }
}

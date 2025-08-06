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
    
    @Binding var post: CommunityPostEntity?
    
    @State private var title: String = ""
    @State private var content: String = ""
    
    init(post: Binding<CommunityPostEntity?>) {
        self._post = post
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
                    }
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
    
    var text: String {
        return self.rawValue
    }
}

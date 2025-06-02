//
//  CreatePostView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/31/25.
//

import SwiftUI
import SCMLogger

struct CreatePostView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    // 텍스트필드
    @State private var titleText: String = ""
    @State private var contentText: String = ""
    
    @State private var isComplete: Bool = false
    
    private let store: StoreBanner
    
    init(store: StoreBanner) {
        self.store = store
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.scmGray15
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 28) {
                    scoopInfoView
                    titleView
                    contentView
                    uploadContentView
                    completeButton
                }
                .padding(20)
                .navigationTitle(StringLiterals.navigationTitle.text)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarItem(leading: {
                    Text(StringLiterals.close.text)
                        .basicText(.PTBody1, .scmGray90)
                        .asButton {
                            dismiss()
                        }
                })
            }
        }
    }
}

// MARK: UI
extension CreatePostView {
    
    // 스쿱 정보
    private var scoopInfoView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(StringLiterals.scoopInfo.text)
                .basicText(.PTTitle6, .scmGray90)
            storeInfoBanner
        }
    }
    
    private var storeInfoBanner: some View {
        StoreInfoBannerCell(store: store)
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
        TextField("", text: $titleText)
            .foregroundStyle(.scmGray90)
            .font(.PTBody2)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .placeholder(StringLiterals.titlePlaceholder.text, $titleText)
            .padding([.bottom, .leading], 8)
            .background(alignment: .bottom) {
                Rectangle()
                    .fill(.scmGray45)
                    .frame(height: 1)
            }
            .overlay(alignment: .trailing) {
                Text("\(titleText.count) / 15")
                    .basicText(.PTBody2, (titleText.count <= 15) ? .scmGray60 : .red)
                    .padding(.trailing, 8)
            }
            .onChange(of: titleText) { newText in
                if newText.count > 15 {
                    titleText = String(newText.prefix(15))
                }
            }
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
        TextEditor(text: $contentText)
            .foregroundStyle(.scmGray90)
            .font(.PTBody2)
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.scmGray60, lineWidth: 0.5)
            )
            .overlay(alignment: .topLeading) {
                if contentText.isEmpty {
                    Text(StringLiterals.contentPlaceholder.text)
                        .basicText(.PTBody2, .scmGray60)
                        .padding(.top, 16)
                        .padding(.leading, 12)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                Text("\(contentText.count) / 300")
                    .basicText(.PTBody2, (contentText.count <= 300) ? .scmGray60 : .red)
                    .padding([.trailing, .bottom], 12)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scrollContentBackground(.hidden)
            .onChange(of: contentText) { newText in
                if newText.count > 300 {
                    contentText = String(newText.prefix(300))
                }
            }
    }
    
    // 사진, 영상 업로드
    private var uploadContentView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(StringLiterals.mediaUpload.text)
                .basicText(.PTTitle6, .scmGray90)
            uploadButton
        }
    }
    
    private var uploadButton: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(Color.scmGray60, lineWidth: 0.5)
            .overlay(alignment: .center) {
                VStack(alignment: .center, spacing: 4) {
                    Image(.cameraFill)
                        .basicImage(width: 26, color: .scmGray60)
                    Text("0 / 3")
                        .basicText(.PTBody2, .scmGray60)
                }
            }
            .frame(width: 68, height: 68)
            .asButton {
                Log.debug("⏭️ 미디어 업로드 버튼 클릭")
            }
    }
    
    // 작성완료 버튼
    private var completeButton: some View {
        NextButtonCell(title: StringLiterals.completeWrite.text, buttonColor: isComplete ? .scmBlackSprout : .scmGray45)
            .asButton({
                Log.debug("⏭️ 작성완료 버튼 클릭")
            }, disabled: !isComplete)
    }
}

// MARK: Action
extension CreatePostView {
    
    private func limitTitleTextCount(_ text: String) {
        guard text.count > 15 else { return }
        
    }
}

// MARK: String Literals
private enum StringLiterals: String {
    case navigationTitle = "작성하기"
    case close = "닫기"
    case scoopInfo = "스쿱 정보"
    case postTitle = "제목"
    case postContent = "포스트 내용"
    case mediaUpload = "사진/영상 업로드"
    case completeWrite = "작성 완료"
    case titlePlaceholder = "제목을 15자 이내로 작성해주세요."
    case contentPlaceholder = "주변 소식통에 올릴 포스트 내용을 작성해 주세요.(300자 이내)"
    
    var text: String {
        return self.rawValue
    }
}

//#Preview {
//    CreatePostView()
//}

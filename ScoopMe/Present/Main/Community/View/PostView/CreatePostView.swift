//
//  CreatePostView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/31/25.
//

import SwiftUI
import NukeUI
import PhotosUI
import SCMLogger

struct CreatePostView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    // 텍스트필드
    @State private var titleText: String = ""
    @State private var contentText: String = ""
    
    @State private var isComplete: Bool = false
    
    // photosUI
    @State private var selectedItems = [PhotosPickerItem]()
    @State private var uploadMedias: [PostMediaItem] = []
    
    private let store: StoreBanner
    
    private var transaction: Transaction {
        var t = Transaction()
        t.animation = .default
        return t
    }
    
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
            .lineSpacing(4)
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
            HStack(alignment: .center, spacing: 20) {
                uploadButton
                selectedAssets
            }
        }
    }
    
    private var uploadButton: some View {
        PhotosPicker(
            selection: $selectedItems,
            maxSelectionCount: 3,
            selectionBehavior: .ordered,
            matching: .any(of: [.images, .videos]),
            photoLibrary: .shared()
        ) {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.scmGray60, lineWidth: 0.5)
                .overlay(alignment: .center) {
                    VStack(alignment: .center, spacing: 2) {
                        Image(.cameraFill)
                            .basicImage(width: 26, color: (uploadMedias.count == 3) ? .scmBlackSprout : .scmGray60)
                        Text("\(uploadMedias.count) / 3")
                            .basicText(.PTBody2, (uploadMedias.count == 3) ? .scmBlackSprout : .scmGray60)
                    }
                }
                .frame(width: 68, height: 68)
        }
        .onChange(of: selectedItems) { newItem in
            Task {
                await loadMedias(newItem)
            }
        }
    }
    
    private var selectedAssets: some View {
        HStack(alignment: .center, spacing: 8) {
            
            ForEach(uploadMedias, id: \.itemIdentifier) { item in
                MediaItemView(item: item) {
                    withTransaction(transaction) {
                        deleteMedia(item)
                    }
                }
            }
        }
        .animation(.default, value: uploadMedias.map { $0.itemIdentifier })
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
    
    // 선택한 미디어 삭제
    private func deleteMedia(_ item: PostMediaItem) {
        // 앨범 아이템에서 삭제
        withTransaction(transaction) {
            if let albumIndex = selectedItems.firstIndex(where: { $0.itemIdentifier == item.itemIdentifier }) {
                selectedItems.remove(at: albumIndex)
            }
            if let uploadIndex = uploadMedias.firstIndex(where: { $0.itemIdentifier == item.itemIdentifier }) {
                uploadMedias.remove(at: uploadIndex)
            }
        }
    }
    
    // 선택한 이미지 로드
    private func loadMedias(_ items: [PhotosPickerItem]) async {
        var newMedias: [PostMediaItem] = []
        
        for item in items {
            guard let data = try? await item.loadTransferable(type: Data.self) else { return }
            
            if let uiImage = UIImage(data: data) {
                let image = Image(uiImage: uiImage)
                let item = PostMediaItem(
                    itemIdentifier: item.itemIdentifier ?? data.description,
                    image: image,
                    videoURL: nil
                )
                newMedias.append(item)
            }
            
            await MainActor.run {
                uploadMedias = newMedias
            }
        }
    }
}

struct Movie: Transferable {
    let url: URL

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { movie in
            SentTransferredFile(movie.url)
        } importing: { received in
            let copy = FileManager.default.temporaryDirectory
                .appendingPathComponent(UUID().uuidString)
                .appendingPathExtension(received.file.pathExtension)
            
            try FileManager.default.copyItem(at: received.file, to: copy)
            return Self.init(url: copy)
        }
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

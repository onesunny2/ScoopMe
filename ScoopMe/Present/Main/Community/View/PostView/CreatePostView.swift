//
//  CreatePostView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/31/25.
//

import SwiftUI
import NukeUI
import PhotosUI
import SCMCommunity
import SCMLogger
import SCMNetwork

struct CreatePostView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var repository: AnyCreatePostDisplayable
    
    // 텍스트필드
    @State private var titleText: String = ""
    @State private var contentText: String = ""
    
    // photosUI
    @State private var selectedItems = [PhotosPickerItem]()
    @State private var uploadMedias: [PostMediaItem] = []
    private let maxPhotoCount: Int = 5
    
    @State private var showAlert: Bool = false  // 닫기 눌렀을 때 알럿창 용도
    @State private var showToastMessage: Bool = false  // 작성 완료한 후 토스트 메시지 용도
    
    private let storeBannerInfo: StoreBanner
    private let postStore: PostStore
    
    private var transaction: Transaction {
        var t = Transaction()
        t.animation = .default
        return t
    }
    private var isComplete: Bool {
        let value = !titleText.isEmpty && !contentText.isEmpty
        return value
    }
    
    private var onWriting: Bool {
        let value = !titleText.isEmpty || !contentText.isEmpty || !uploadMedias.isEmpty
        return value
    }
    
    init(
        repository: AnyCreatePostDisplayable,
        storeBannerInfo: StoreBanner,
        postStore: PostStore
    ) {
        self._repository = StateObject(wrappedValue: repository)
        self.storeBannerInfo = storeBannerInfo
        self.postStore = postStore
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
                            if !onWriting { dismiss() }
                            else { showAlert = true }
                        }
                })
                .showAlert(
                    isPresented: $showAlert,
                    title: StringLiterals.alertTitle.text,
                    message: StringLiterals.alertMessage.text,
                    multiAction: { dismiss() })
            }
            .overlay(alignment: .center) {
                if showToastMessage {
                    ToastView(
                        isShowing: $showToastMessage,
                        message: ToastMessage(
                            text: StringLiterals.toastMessage.text,
                            type: .success
                        )
                    )
                }
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
        StoreInfoBannerCell(store: storeBannerInfo)
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
            titleText: $titleText,
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
            contentText: $contentText,
            placeholder: StringLiterals.contentPlaceholder.text
        )
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
            maxSelectionCount: 5,
            selectionBehavior: .ordered,
            matching: .any(of: [.images, .videos]),
            photoLibrary: .shared()
        ) {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.scmGray60, lineWidth: 0.5)
                .overlay(alignment: .center) {
                    VStack(alignment: .center, spacing: 2) {
                        Image(.cameraFill)
                            .basicImage(width: 26, color: (uploadMedias.count == maxPhotoCount) ? .scmBlackSprout : .scmGray60)
                        Text("\(uploadMedias.count) / \(maxPhotoCount)")
                            .basicText(.PTBody2, (uploadMedias.count == maxPhotoCount) ? .scmBlackSprout : .scmGray60)
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
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 8) {
                
                ForEach(uploadMedias, id: \.itemIdentifier) { item in
                    MediaItemView(item: item) {
                        withTransaction(transaction) {
                            deleteMedia(item)
                        }
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
                Task {
                    await postFiles()
                    handleToastMessage()
                }
            }, disabled: !isComplete)
    }
}

// MARK: Action
extension CreatePostView {

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
            guard let utType = UTTypeHelper.getUTTypeFromImageData(data) else { return }
            
            if let uiImage = UIImage(data: data) {
                let item = PostMediaItem(
                    itemIdentifier: item.itemIdentifier ?? data.description,
                    image: uiImage,
                    videoURL: nil,
                    utType: String(utType.preferredMIMEType ?? "image/jpeg")
                )
                newMedias.append(item)
            }

            uploadMedias = newMedias
        }
    }
    
    // post 통신 (1차는 파일 업로드, 2차는 업로드한 파일 통신받은 후 게시글 post)
    private func postFiles() async {
        do {
            try await requestFileAndContents()
            
        } catch {
            await repository.checkTokenValidation(error) {
                try await requestFileAndContents()
            }
        }
    }
    
    private func requestFileAndContents() async throws {
        if !uploadMedias.isEmpty {
            var files: [FileData] = []
            uploadMedias.forEach { item in
                guard let image = item.image, item.isImage else { return }
                let file = FileData.image(image, fileName: item.itemIdentifier, mimeType: item.utType)
                Log.debug("🔗 업로드 타입: \(item.utType)")
                files.append(file)
                // TODO: 비디오 추가 필요
            }
            
            let urls = try await repository.postFiles(files)
            
            // url 전달받아 post 업로드 통신
            await postContents(urls.files)
        } else {
            await postContents([])
        }
    }
    
    // post content 업로드
    private func postContents(_ files: [String]) async {
        do {
            try await requestContents(files)
        } catch {
            await repository.checkTokenValidation(error) {
                try await requestContents(files)
            }
        }
    }
    
    private func requestContents(_ files: [String]) async throws {
        let content = PostContent(
            categoty: postStore.category,
            title: titleText,
            content: contentText,
            storeID: postStore.storeID,
            latitude: postStore.latitude,
            longitude: postStore.longitude,
            files: files
        )
        try await repository.postContents(content)
    }
    
    // toastMessage 관리
    private func handleToastMessage() {
        showToastMessage = true
        
        Task {
            try? await Task.sleep(for: .seconds(2))
            await MainActor.run {
                showToastMessage = false
                dismiss()
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
    case alertTitle = "안내"
    case alertMessage = "현재 작성 중인 내용이 있습니다. 뒤로가면 해당 내용은 삭제됩니다. 나가시겠습니까?"
    case toastMessage = "포스트가 성공적으로 업로드 되었습니다 :>"
    
    var text: String {
        return self.rawValue
    }
}

//
//  CommunityView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/17/25.
//

import SwiftUI
import SCMCommunity
import SCMLogger

struct CommunityView: View {
    
    private let repository: CommunityPostDisplayable
    private let chatListRepository: ChatListDisplayable
    
    @State private var debounceTask: Task<Void, Never>?  // 잦은 호출방지
    
    // pagination
    @State private var isLoading: Bool = false
    @State private var cursorID: String? = nil
    
    @State private var searchKeyword: String = ""
    @State private var volume: CGFloat = 0.3
    
    @State private var selectedFilter: TimelineFilter = .최신순
    @State private var posts: [CommunityPostEntity] = []
    
    // 채팅창 호출 트리거
    @State private var isMessageOpened: Bool = false
    @State private var roomID: String = ""
    @State private var opponentName: String = ""
    @State private var opponentID: String = ""
    
    // 게시글 수정, 삭제
    @State private var isPostDeleted: Bool = false
    @State private var deletePostID: String = ""
    @State private var isPostEdited: Bool = false
    @State private var editPost: CommunityPostEntity? = nil
    @State private var isEditCompleted: Bool = false
    @State private var isEditFailed: Bool = false
    
    // 댓글
    @State private var tappedComments: Bool = false
    @State private var postComments: [CommentResponseDTO] = []
    
    init(repository: CommunityPostDisplayable, chatListRepository: ChatListDisplayable) {
        self.repository = repository
        self.chatListRepository = chatListRepository
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                SearchTextFieldCell(
                    placeholder: StringLiterals.placeholder.text,
                    keyword: $searchKeyword
                )
                
                distanceSliderCell
                timelineTitleAndFilter
                
                if !posts.isEmpty {
                    postContentsView
                } else {
                    noResultsView
                }
            }
            .defaultHorizontalPadding()
            .navigationTitle(StringLiterals.navigationTitle.text)
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await getCommunityPost()
            }
            .onChange(of: volume) { _ in
                applyDebounceForRequestPost()
            }
            .onChange(of: selectedFilter) { _ in
                cursorID = nil
                Task { await getCommunityPost() }
            }
            .fullScreenCover(isPresented: $isMessageOpened) {
                NavigationStack {
                    ChatRoomView(
                        chatRoomRepository: DIContainer.shared.chatRoomRepository,
                        socketChatManager: DIContainer.shared.socketChatManager,
                        notificationBadgeManager: DIContainer.shared.notificationBadgeManager,
                        roomID: $roomID,
                        opponentName: $opponentName
                    )
                }
            }
            .sheet(isPresented: $isPostEdited) {
                EditPostContentView(
                    post: $editPost,
                    isEditCompleted: $isEditCompleted,
                    iseditFailed: $isEditFailed
                ) { newPost in
                    Task {
                        await editPost(postID: editPost?.postID ?? "", content: newPost)
                    }
                } tappedResave: { newPost in
                    Task {
                        await editPost(postID: editPost?.postID ?? "", content: newPost)
                    }
                }
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $tappedComments) {
                PostCommentView(
                    imageHelper: DIContainer.shared.imageHelper,
                    comments: postComments
                )
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
            }
            .showAlert(
                isPresented: $isPostDeleted,
                title: "삭제",
                message: "해당 포스트를 삭제하시겠습니까?",
                buttonTitle: nil) {
                    Task {
                        await deletePost(postID: deletePostID)
                    }
                }
        }
    }
}

// MARK: UI
extension CommunityView {
    
    private var distanceSliderCell: some View {
        HStack(alignment: .center, spacing: 8) {
            Text(StringLiterals.distance.text + ": " + String(format: "%.2f", volume) + "km")
                .basicText(.PTBody4, .scmBlackSprout)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 4).fill(.scmGray15)
                        .overlay {
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.scmBlackSprout, lineWidth: 0.5)
                        }
                )
                .animation(nil, value: volume)
            
            ExpendableSliderCell(value: $volume, in: 0...1) {
                HStack {
                    Image(.distance)
                        .basicImage(width: 24, color: .scmBrightSprout)
                    
                    Spacer()
                }
                .defaultHorizontalPadding()
            }
        }
    }
    
    private var timelineTitleAndFilter: some View {
        HStack(alignment: .center) {
            Text(StringLiterals.timelineTitle.text)
                .basicText(.PTTitle4, .scmGray90)
            
            Spacer()
            
            HStack(alignment: .center, spacing: 4) {
                Text(selectedFilter.text)
                    .basicText(.PTCaption1, .scmBlackSprout)
                Image(.list)
                    .basicImage(width: 16, color: .scmBlackSprout)
            }
            .asButton {
                switch selectedFilter {
                case .최신순: selectedFilter = .좋아요순
                case .좋아요순: selectedFilter = .최신순
                @unknown default:
                    selectedFilter = .최신순
                }
            }
        }
        .padding(.bottom, -14)
    }
    
    @ViewBuilder
    private var postContentsView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(posts, id: \.postID) { post in
                        Rectangle()
                            .fill(.scmBrightSprout)
                            .frame(height: 1)
                        
                        CommunityPostCell(
                            post: post,
                            tappedMessage: { creator in
                                opponentID = creator.id
                                opponentName = creator.nickname
                                Log.debug("🔗 상대방이름: \(opponentName)", "상대방ID: \(opponentID)")
                                
                                Task {
                                    let success = await fetchRoomID()
                                    
                                    if success {
                                        isMessageOpened = true
                                    }
                                }
                            },
                            tappedDelete: { postID in
                                isPostDeleted = true
                                deletePostID = postID
                            },
                            tappedEdit: { post in
                                isPostEdited = true
                                editPost = post
                            },
                            tappedComment: { post in
                                tappedComments = true
                                postComments = post.comments
                            })
                        .padding(.vertical, 12)
                        .onAppear {
                            if (post.postID == posts.last?.postID) && cursorID != "0" {
                                Task { await getCommunityPostForPagination() }
                            }
                        }
                    }
                }
                .padding(.top, 6)
                
                if isLoading {
                    ProgressView()
                        .padding(4)
                }
            }
        }
    }
    
    private var noResultsView: some View {
        VStack {
            Spacer()
            Text(StringLiterals.noResults.text)
                .basicText(.PTBody1, .scmGray90)
            Spacer()
        }
    }
}

// MARK: Action
extension CommunityView {
    
    // 위치기반 포스트 호출
    private func getCommunityPost() async {
        do {
            isLoading = true
            
            let posts = try await repository.getCommunityPost(
                max: Int(volume * 1000),
                orderBy: selectedFilter,
                next: cursorID
            )
            cursorID = posts.next
            self.posts = posts.data
            
            isLoading = false
        } catch {
            Log.error("데이터 로드 실패: \(error)")
        }
    }
    
    // 페이지네이션 전용
    private func getCommunityPostForPagination() async {
        do {
            isLoading = true
            
            let posts = try await repository.getCommunityPost(
                max: Int(volume * 1000),
                orderBy: selectedFilter,
                next: cursorID
            )
            self.posts.append(contentsOf: posts.data)
            cursorID = posts.next
            
            isLoading = false
        } catch {
            Log.error("데이터 로드 실패: \(error)")
        }
    }
    
    // 포스트 호출 debounce
    private func applyDebounceForRequestPost() {
        debounceTask?.cancel()
        
        debounceTask = Task {
            try? await Task.sleep(for: .seconds(0.5))
            
            if !Task.isCancelled {
                await getCommunityPost()
            }
        }
    }
    
    // 채팅창 진입 시 roomID 체크
    private func fetchRoomID() async -> Bool {
        do {
            let fetchedRoomID = try await chatListRepository.getChatroomID(opponent: opponentID)
            
            await MainActor.run {
                self.roomID = fetchedRoomID
            }
            Log.debug("✅ 조회된 roomID: \(self.roomID)")
            
            return !fetchedRoomID.isEmpty
        } catch {
            Log.error("❌ roomID 조회에 실패했습니다: \(error)")
            return false
        }
    }
    
    // 포스트 삭제
    private func deletePost(postID: String) async {
        do {
            try await repository.deleteCommunityPost(postID: postID)
            
            guard let index = posts.firstIndex(where: {
                $0.postID == postID
            }) else { return }
            
            posts.remove(at: index)  // 해당 포스트 삭제!
            
        } catch {
            Log.error("❌ 포스트 삭제 실패: \(error)")
            isEditFailed = true
        }
    }
    
    // 포스트 수정
    private func editPost(
        postID: String,
        content: EditContent
    ) async {
        do {
            try await repository.editContents(postID: postID, content: content)
            
            // 여기서 수정한 게시글 데이터 업데이트 해줘야 함!
            guard let index = posts.firstIndex(where: { $0.postID == postID }) else { return }
            posts[index].postTitle = content.title
            posts[index].postContent = content.content
            
            isEditCompleted = true
        } catch {
            Log.error("❌ 포스트 수정 실패: \(error)")
            isEditFailed = true
        }
    }
}

// MARK: StringLiterals
private enum StringLiterals: String {
    case navigationTitle = "스쿱미 소식통"
    case placeholder = "검색어를 입력해주세요."
    case timelineTitle = "포스트"
    case distance = "범위"
    case noResults = "조건에 맞는 포스트가 없습니다"
    
    var text: String {
        return self.rawValue
    }
}

#Preview {
    CommunityView(repository: DIContainer.shared.communityPostRepository, chatListRepository: DIContainer.shared.chatListRepository)
}


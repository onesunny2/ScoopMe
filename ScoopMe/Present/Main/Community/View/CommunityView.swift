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
    
    private var repository: CommunityPostDisplayable
    
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
    
    init(repository: CommunityPostDisplayable) {
        self.repository = repository
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
            .sheet(isPresented: $isMessageOpened) {
                ChatRoomView()
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
                        CommunityPostCell(post: post, isMessageOpened: $isMessageOpened)
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
}

// MARK: StringLiterals
private enum StringLiterals: String {
    case navigationTitle = "스쿱미 소식통"
    case placeholder = "검색어를 입력해주세요."
    case timelineTitle = "포스트"
    case distance = "범위"
    case noResults = "조건에 맞는 포스트가 없습니다 :<"
    
    var text: String {
        return self.rawValue
    }
}

#Preview {
    CommunityView(repository: DIContainer.shared.communityPostRepository)
}
 

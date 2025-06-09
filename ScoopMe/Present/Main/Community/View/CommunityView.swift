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
    
    @StateObject private var repository: AnyCommunityPostDisplayable
    
    @State private var debounceTask: Task<Void, Never>?  // 잦은 호출방지
    @State private var cursorID: String? = nil
    
    @State private var searchKeyword: String = ""
    @State private var volume: CGFloat = 0.3
    
    @State private var selectedFilter: TimelineFilter = .최신순
    @State private var posts: [CommunityPostEntity] = []
    
    init(repository: AnyCommunityPostDisplayable) {
        self._repository = StateObject(wrappedValue: repository)
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
                
                ScrollView(.vertical, showsIndicators: false) {
                    postContentsView
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
                applyDebounceForRequestPost()
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
            
            // TODO: repostory 생기면 변경필요
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
    
    private var postContentsView: some View {
        ForEach(posts, id: \.postID) { post in
            Rectangle()
                .fill(.scmBrightSprout)
                .frame(height: 1)
            CommunityPostCell(post: post)
                .padding(.vertical, 12)
        }
        .padding(.top, 6)
    }
}

// MARK: Action
extension CommunityView {
    
    // 위치기반 포스트 호출
    private func getCommunityPost() async {
        do {
            let posts = try await repository.getCommunityPost(
                max: Int(volume * 1000),
                orderBy: selectedFilter,
                next: cursorID
            )
            self.posts = posts.data
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
    
    var text: String {
        return self.rawValue
    }
}

#Preview {
    CommunityView(repository: DIContainer.shared.communityPostRepository)
}
 

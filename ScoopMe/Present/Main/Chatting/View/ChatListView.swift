//
//  ChatListView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 6/25/25.
//

import SwiftUI
import SCMChat
import SCMLogger

struct ChatListView: View {
    
    private let chatListRepository: ChatListDisplayable
    @State private var chatListItems: [ChatListItemEntity] = []
    
    init(chatListRepository: ChatListDisplayable) {
        self.chatListRepository = chatListRepository
    }
    
    var body: some View {
        NavigationStack {
            chatContainerView
            .navigationTitle(stringLiterals.navigationTitle.text)
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await loadChatLists()
            }
        }
    }
}



// MARK: UI
extension ChatListView {
    
    // 채팅유무에 따른 분기처리
    @ViewBuilder
    private var chatContainerView: some View {
        if chatListItems.isEmpty {
            emptyView
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                chatLists
            }
        }
    }
    
    private var chatLists: some View {
        LazyVStack(alignment: .center, spacing: 0) {
            ForEach(chatListItems, id: \.userID) { item in
                ChatListCell(entity: item)
                    .padding(.vertical, 10)
                    .defaultHorizontalPadding()
            }
        }
    }
    
    // emptyView
    private var emptyView: some View {
        HStack {
            Image(.xmarkCircleFill)
                .basicImage(width: 25, color: .scmDeepSprout)
            Text(stringLiterals.empty.text)
                .basicText(.PTBody1, .scmGray75)
        }
    }
}

// MARK: Action
extension ChatListView {
    
    // 채팅목록 로딩
    private func loadChatLists() async {
        do {
            let lists = try await chatListRepository.getChatLists()
            self.chatListItems = lists
            
            Log.debug("✅ 채팅목록 불러오기 성공")
        } catch {
            Log.error("❎ 채팅목록 불러오기 실패: \(error)")
        }
    }
}

// MARK: StringLiterals
private enum stringLiterals: String {
    case navigationTitle = "채팅목록"
    case empty = "주고받은 채팅이 없습니다."
    
    var text: String {
        return self.rawValue
    }
}

#Preview {
    ChatListView(chatListRepository: DIContainer.shared.chatListRepository)
}

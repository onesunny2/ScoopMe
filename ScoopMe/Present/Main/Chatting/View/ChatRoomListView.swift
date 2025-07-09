//
//  ChatListView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 6/25/25.
//

import SwiftUI
import SCMChat
import SCMLogger

struct ChatRoomListView: View {
    
    private let chatListRepository: ChatListDisplayable
    @StateObject private var router = SCMRouter<ChatPath>.shared
    
    @State private var chatListItems: [ChatListItemEntity] = []
    @State private var opponentName: String = ""
    
    init(chatListRepository: ChatListDisplayable) {
        self.chatListRepository = chatListRepository
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack(spacing: 0) {
                AdBannerCell(imageHelper: DIContainer.shared.imageHelper)
                chatContainerView
            }
            .navigationTitle(stringLiterals.navigationTitle.text)
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await loadChatLists()
            }
            .navigationDestination(for: ChatPath.self) { router in
                switch router {
                case let .chatRoom(roomID):
                    ChatRoomView(
                        chatRoomRepository: DIContainer.shared.chatRoomRepository,
                        roomID: roomID,
                        opponentName: $opponentName
                    )
                }
            }
        }
    }
}



// MARK: UI
extension ChatRoomListView {
    
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
                ChatRoomListCell(entity: item)
                    .padding(.vertical, 10)
                    .defaultHorizontalPadding()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        Log.debug("⏭️ 채팅창 클릭")
                        router.send(.push(
                            .chatRoom(
                                roomID: item.roomID))
                        )
                    }
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
extension ChatRoomListView {
    
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
    ChatRoomListView(chatListRepository: DIContainer.shared.chatListRepository)
}

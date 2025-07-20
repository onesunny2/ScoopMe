//
//  ChatListView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 6/25/25.
//

import SwiftUI
import RealmSwift
import SCMLogger

struct ChatRoomListView: View {
    
    private let chatListRepository: ChatListDisplayable
    @StateObject private var router = SCMRouter<ChatPath>.shared
    
    @ObservedResults(
        ChatRoom.self,
        sortDescriptor: SortDescriptor(keyPath: "lastMessageAt", ascending: false)
    ) var chatListItems
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
                Log.debug("✅ 저장된 채팅 목록")
            }
            .navigationDestination(for: ChatPath.self) { router in
                switch router {
                case let .chatRoom(roomID):
                    ChatRoomView(
                        chatRoomRepository: DIContainer.shared.chatRoomRepository,
                        roomID: roomID,
                        opponentName: $opponentName
                    )
                    .toolbar(.hidden, for: .tabBar)
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                chatLists
            }
        }
    }
    
    private var chatLists: some View {
        LazyVStack(alignment: .center, spacing: 0) {
            ForEach(chatListItems, id: \.roomID) { item in
                ChatRoomListCell(room: item)
                    .padding(.vertical, 10)
                    .defaultHorizontalPadding()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        opponentName = item.participant?.nickname ?? ""
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
            try await chatListRepository.checkChatLists()
            
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

//
//  ChatListView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 6/25/25.
//

import SwiftUI
import SCMChat

struct ChatListView: View {
    
    private let chatListRepository: ChatListDisplayable
    private let entities: [ChatListItemEntity] = []
    
    init(chatListRepository: ChatListDisplayable) {
        self.chatListRepository = chatListRepository
    }
    
    var body: some View {
        NavigationStack {
            chatContainerView
            .navigationTitle(stringLiterals.navigationTitle.text)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}



// MARK: UI
extension ChatListView {
    
    // 채팅유무에 따른 분기처리
    @ViewBuilder
    private var chatContainerView: some View {
        if entities.isEmpty {
            emptyView
        } else {
            chatLists
        }
    }
    
    private var chatLists: some View {
        LazyVStack(alignment: .center, spacing: 0) {
            ForEach(entities, id: \.userID) { entity in
                ChatListCell(entity: entity)
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

//
//  ChatListCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 6/25/25.
//

import SwiftUI
import SCMChat

struct ChatListCell: View {
    
    private let entity: ChatListItemEntity
    
    init(entity: ChatListItemEntity) {
        self.entity = entity
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            NukeRequestImageCell(
                imageHelper: DIContainer.shared.imageHelper,
                url: entity.profileImageURL,
                topLeading: 16,
                bottomLeading: 16,
                bottomTrailing: 16,
                topTrailing: 16
            )
            .frame(width: 40, height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            // 이름, 채팅내용
            VStack(alignment: .leading, spacing: 4) {
                Text(entity.username)
                    .basicText(.PTBody6, .scmGray100)
                Text(entity.recentMessage)
                    .basicText(.PTCaption6, .scmGray75)
            }
            
            Spacer(minLength: 8)
            
            // 시간, 알림뱃지
            VStack(alignment: .trailing, spacing: 4) {
                Text(entity.recentTime)
                    .basicText(.PTCaption6, .scmGray90)
                
                Circle()
                    .fill(Color.scmBlackSprout)
                    .frame(width: 12, height: 12)
                    .overlay(alignment: .center) {
                        Text(entity.messageCountString)
                            .basicText(.PTCaption7, .scmGray0)
                    }
            }
        }
    }
}

#Preview {
    let entity: ChatListItemEntity = ChatListItemEntity(
        userID: "",
        roomID: "",
        profileImageURL: "",
        username: "이짜몽",
        recentMessage: "왜 짜몽이는 항상 사람이 있어야 밥을 먹을까?",
        recentTime: "오후 4:21",
        messageCount: 2
    )
    
    ChatListCell(entity: entity)
}

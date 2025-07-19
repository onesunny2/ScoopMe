//
//  ChatRoomListCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 6/25/25.
//

import SwiftUI

struct ChatRoomListCell: View {
    
    private let room: ChatRoom
    
    init(room: ChatRoom) {
        self.room = room
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            NukeRequestImageCell(
                imageHelper: DIContainer.shared.imageHelper,
                url: room.participant?.profileImage ?? "",
                topLeading: 16,
                bottomLeading: 16,
                bottomTrailing: 16,
                topTrailing: 16
            )
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            // 이름, 채팅내용
            VStack(alignment: .leading, spacing: 4) {
                Text(room.participant?.nickname ?? "")
                    .basicText(.PTTitle5, .scmGray100)
                Text(room.lastMessageContent)
                    .basicText(.PTBody6, .scmGray75)
                    .lineLimit(2)
            }
            
            Spacer(minLength: 8)
            
            // 시간, 알림뱃지
            VStack(alignment: .trailing, spacing: 4) {
                Text(room.lastMessageAt.isoStringToKoreanAMPM() ?? "")
                    .basicText(.PTBody6, .scmGray75)
                
                if room.unreadCount != nil {
                    Circle()
                        .fill(Color.scmBlackSprout)
                        .frame(width: 16, height: 16)
                        .overlay(alignment: .center) {
                            Text("\(room.unreadCount)")
                                .basicText(.PTBody6, .scmGray0)
                        }
                }
            }
        }
    }
}

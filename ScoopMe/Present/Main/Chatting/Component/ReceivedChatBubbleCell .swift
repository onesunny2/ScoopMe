//
//  ReceivedChatBubbleCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 6/26/25.
//

import SwiftUI
import SCMLogger

struct ReceivedChatBubbleCell: View {
    
    private let participant: Participant
    private let sendDate: String
    private let message: String
    private let onDeleteTapped: () -> Void
    
    init(
        participant: Participant,
        sendDate: String,
        message: String,
        onDeleteTapped: @escaping () -> Void
    ) {
        self.participant = participant
        self.sendDate = sendDate
        self.message = message
        self.onDeleteTapped = onDeleteTapped
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            profileImageView
            messageInfo
            Spacer(minLength: 4)
        }
    }
}

// MARK: UI
extension ReceivedChatBubbleCell {
    private var profileImageView: some View {
        NukeRequestImageCell(
            imageHelper: DIContainer.shared.imageHelper,
            url: participant.profileImage ?? "",
            topLeading: 16,
            bottomLeading: 16,
            bottomTrailing: 16,
            topTrailing: 16
        )
        .frame(width: 45, height: 45)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var messageInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(participant.nickname)
                .basicText(.PTTitle5, .scmGray90)
            
            HStack(alignment: .bottom, spacing: 4) {
                Text(message)
                    .basicText(.PTTitle5, .scmGray100)
                    .padding(12)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.scmGray15)
                    }
                    .contentShape(RoundedRectangle(cornerRadius: 10))
                    .contextMenu {
                        Button {
                            Log.debug("메시지 삭제하기 버튼 클릭")
                            onDeleteTapped()
                        } label: {
                            Label("삭제하기", systemImage: "trash")
                        }
                        
                    }
                
                Text(sendDate.isoStringToKoreanAMPM() ?? "")
                    .basicText(.PTBody5, .scmGray90)
            }
        }
    }
}

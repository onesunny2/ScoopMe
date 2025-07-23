//
//  MyChatBubbleCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 6/26/25.
//

import SwiftUI
import SCMLogger

struct MyChatBubbleCell: View {
    
    private let sendDate: String
    private let message: String
    private let sendStatus: String
    private let onResendTapped: () -> Void
    private let onDeleteTapped: () -> Void
    
    init(
        sendDate: String,
        message: String,
        sendStatus: String,
        onResendTapped: @escaping () -> Void,
        onDeleteTapped: @escaping () -> Void
    ) {
        self.sendDate = sendDate
        self.message = message
        self.sendStatus = sendStatus
        self.onResendTapped = onResendTapped
        self.onDeleteTapped = onDeleteTapped
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            Spacer(minLength: 4)
            
            if sendStatus == MessageSendStatus.failed.string {
                Image(.arrowCounterclockwiseCircleFill)
                    .basicImage(width: 20, color: .scmGray45)
                    .asButton {
                        Log.debug("🔗 재전송버튼 클릭")
                        onResendTapped()
                    }
            }
            
            Text(sendDate.isoStringToKoreanAMPM() ?? "")
                .basicText(.PTBody5, .scmGray90)
            Text(message)
                .basicText(.PTTitle5, .scmGray100)
                .padding(12)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.scmDeepSprout)
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
        }
    }
}

//#Preview {
//    MyChatBubbleCell(isSendFailed: .constant(false), sendDate: "오후 10:51", message: "여기는 지금 비 안오는데 거기는 오고 있어?")
//}

//
//  ReceivedChatBubbleCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 6/26/25.
//

import SwiftUI

struct ReceivedChatBubbleCell: View {
    
    private let profileImageURL: String
    private let senderName: String
    private let sendDate: String
    private let message: String
    
    init(profileImageURL: String, senderName: String, sendDate: String, message: String) {
        self.profileImageURL = profileImageURL
        self.senderName = senderName
        self.sendDate = sendDate
        self.message = message
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
            url: profileImageURL,
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
            Text(senderName)
                .basicText(.PTTitle8, .scmGray90)
            
            HStack(alignment: .bottom, spacing: 4) {
                Text(message)
                    .basicText(.PTTitle8, .scmGray100)
                    .padding(12)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.scmGray15)
                    }
                
                Text(sendDate)
                    .basicText(.PTBody5, .scmGray90)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.scmBrightSprout
            .ignoresSafeArea()
        ReceivedChatBubbleCell(profileImageURL: "", senderName: "마망", sendDate: "오후 5:30", message: "오늘 저녁 메뉴 뭐 먹고싶은지 후보 보내줘~")
    }
}

//
//  ChatRoomView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/17/25.
//

import SwiftUI

struct ChatRoomView: View {
    
    private let sendMessageHeight: CGFloat = 40
    
    var body: some View {
        ZStack {
            Color.scmBrightSprout
                .ignoresSafeArea()
            
            chatContainerView
        }
    }
}

// MARK: UI
extension ChatRoomView {
    
    // 전체 내용 컨테이너 - VStack으로 변경하여 올바른 레이아웃 구성
    @ViewBuilder
    private var chatContainerView: some View {
        VStack(spacing: 0) {
            // 상단 고정 영역
            topUserInfoView
                .defaultHorizontalPadding()
                .background(Color.scmBrightSprout) // 배경색 추가로 스크롤 시 겹침 방지
            
            // 중간 스크롤 영역
            ScrollView(.vertical, showsIndicators: false) {
                messagesView
                    .padding(.bottom, 12) // 마지막 메시지와 하단 뷰 사이 여백
            }
            .defaultHorizontalPadding()
            
            // 하단 고정 영역
            bottomSendMessageView
        }
    }
    
    // 상단 상대방 정보
    private var topUserInfoView: some View {
        HStack(alignment: .center, spacing: 8) {
            NukeRequestImageCell(
                imageHelper: DIContainer.shared.imageHelper,
                url: "",
                topLeading: 16,
                bottomLeading: 16,
                bottomTrailing: 16,
                topTrailing: 16
            )
            .frame(width: 55, height: 55)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("이짜몽")
                    .basicText(.PTTitle2, .scmGray100)
                
                Text("가게이름")
                    .basicText(.PTTitle5, .scmGray75)
            }
            
            Spacer()
        }
        .padding(.vertical, 12)
    }
    
    // 하단 메시지 전송
    private var bottomSendMessageView: some View {
        HStack(alignment: .center, spacing: 8) {
            RoundedRectangle(cornerRadius: sendMessageHeight / 2)
                .fill(Color.scmGray45)
                .frame(height: sendMessageHeight)
            
            Circle()
                .fill(Color.scmGray45)
                .frame(width: sendMessageHeight)
        }
        .padding(.vertical, 12)
        .defaultHorizontalPadding()
        .frame(maxWidth: .infinity)
        .background(.scmGray15)
        .ignoresSafeArea(.container, edges: .bottom)
    }
    
    // 중단 채팅내역
    private var messagesView: some View {
        LazyVStack(alignment: .center, spacing: 16) {
            ForEach(0..<1, id: \.self) { _ in
                MyChatBubbleCell(sendDate: "오후 9:50", message: "나 이제 슬슬 마무리해!")
                MyChatBubbleCell(sendDate: "오후 9:51", message: "그 다음에 오는 버스 탈 것 같아")
                ReceivedChatBubbleCell(profileImageURL: "", senderName: "이짜몽", sendDate: "오후 9:54", message: "버스는 몇시에 온대??")
            }
        }
        .padding(.top, 12)
    }
}

// MARK: StringLiterals
private enum StringLiterals: String {
    case messagePlaceholder = "메시지 입력"
    
    var text: String {
        return self.rawValue
    }
}

#Preview {
    ChatRoomView()
}

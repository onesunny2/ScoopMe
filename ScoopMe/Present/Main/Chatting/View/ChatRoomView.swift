//
//  ChatRoomView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/17/25.
//

import SwiftUI
import SCMChat
import SCMLogger

struct ChatRoomView: View {
    
    @State private var textMessage: String = ""
    @State private var sendStatus: Bool = false
    @FocusState private var focusBinding: Bool
    
    @State private var messages: [EachChatMessageEntity] = []
    
    private let chatRoomRepository: ChatRoomDisplayable
    private let roomID: String
    private let opponentName: String
    
    init(chatRoomRepository: ChatRoomDisplayable, roomID: String, opponentName: String) {
        self.chatRoomRepository = chatRoomRepository
        self.roomID = roomID
        self.opponentName = opponentName
    }
    
    var body: some View {
        ZStack {
            Color.scmBrightSprout
                .ignoresSafeArea()
            
            chatContainerView
                .contentShape(Rectangle())
                .onTapGesture {
                    focusBinding = false
                }
        }
        .navigationTitle(opponentName)
        .navigationBarTitleDisplayMode(.inline)
        .backButton(.scmBlackSprout)
        .task {
            await getServerMessages()
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
//            topUserInfoView
//                .defaultHorizontalPadding()
//                .background(Color.scmBrightSprout)
//                .overlay(alignment: .bottom) {
//                    Rectangle()
//                        .fill(Color.scmGray60)
//                        .frame(height: 0.5)
//                }
            
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
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("이짜몽")
                    .basicText(.PTBody1, .scmGray100)
                
                Text("가게이름")
                    .basicText(.PTBody6, .scmGray75)
            }
            
            Spacer()
        }
        .padding(.vertical, 12)
    }
    
    // 하단 메시지 전송
    private var bottomSendMessageView: some View {
        ChatInputView(textMessage: $textMessage, sendStatus: $sendStatus, focusBinding: $focusBinding)
            .onChange(of: sendStatus) { newStatus in
                if newStatus {
                    // 메시지가 비어있지 않을 때만 추가
                    if !textMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        let newMessage = EachChatMessageEntity(
                            chatID: "9999",
                            sender: .me,
                            senderInfo: nil,
                            content: textMessage,
                            files: [],
                            sendDate: Date(),
                            sendDateString: "오후 2:40"
                        )
                        messages.append(newMessage)
                    }
                    sendStatus = false
                    textMessage = ""
                }
            }
    }
    
    // 중단 채팅내역
    private var messagesView: some View {
        LazyVStack(alignment: .center, spacing: 16) {
            ForEach(messages, id: \.chatID) { message in
                seperateSenderView(message: message)
            }
        }
        .padding(.top, 12)
    }
    
    @ViewBuilder
    private func seperateSenderView(message: EachChatMessageEntity) -> some View {
        if message.sender == .me {
            MyChatBubbleCell(sendDate: message.sendDateString, message: message.content)
        } else {
            ReceivedChatBubbleCell(
                profileImageURL: message.senderInfo?.profileURL ?? "",
                senderName: message.senderInfo?.nickname ?? "알수없음",
                sendDate: message.sendDateString,
                message: message.content
            )
        }
    }
}

// MARK: Action
extension ChatRoomView {
    // message 호출
    private func getServerMessages() async {
        do {
            let messages = try await chatRoomRepository.getChatMessages()
            self.messages = messages
        } catch {
            Log.error("❎ 서버에서 메시지 로딩 실패: \(error)")
        }
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
    ChatRoomView(chatRoomRepository: DIContainer.shared.chatRoomRepository, roomID: "", opponentName: "아무개")
}

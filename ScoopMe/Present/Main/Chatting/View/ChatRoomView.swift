//
//  ChatRoomView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/17/25.
//

import SwiftUI
import SCMLogger

struct ChatRoomView: View {
    
    @State private var textMessage: String = ""
    @State private var resendMessage: String = ""
    @State private var sendStatus: Bool = false
    @FocusState private var focusBinding: Bool
    
    @State private var messages: [EachChatMessageEntity] = []
    
    private let chatRoomRepository: ChatRoomDisplayable
    private let roomID: String
    @Binding var opponentName: String
    
    init(chatRoomRepository: ChatRoomDisplayable, roomID: String, opponentName: Binding<String>) {
        self.chatRoomRepository = chatRoomRepository
        self.roomID = roomID
        self._opponentName = opponentName
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
            ScrollView(.vertical, showsIndicators: false) {
                messagesView
                    .padding(.bottom, 12) // 마지막 메시지와 하단 뷰 사이 여백
            }
            .defaultHorizontalPadding()
            
            // 하단 고정 영역
            bottomSendMessageView
        }
    }
    
    // 하단 메시지 전송
    private var bottomSendMessageView: some View {
        ChatInputView(textMessage: $textMessage, sendStatus: $sendStatus, focusBinding: $focusBinding)
            .onChange(of: sendStatus) { newStatus in
                if newStatus {
                    // 메시지가 비어있지 않을 때만 추가
                    if !textMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Task {
                            await postMessageToServer()
                        }
                    }
                    sendStatus = false
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
            MyChatBubbleCell(sendDate: message.sendDate, message: message.content, sendStatus: message.sendStatus) {
                Task {
                    resendMessage = message.content
                    await resendMessageToServer()
                }
            }
        } else {
            ReceivedChatBubbleCell(
                profileImageURL: message.senderInfo?.profileURL ?? "",
                senderName: message.senderInfo?.nickname ?? "알수없음",
                sendDate: message.sendDate,
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
            let messageInfo = GetMessages(roomID: roomID, lastMessageDate: "2025-05-06T05:13:54.357Z")
            let messages = try await chatRoomRepository.getChatMessages(messageInfo: messageInfo)
            self.messages = messages
        } catch {
            Log.error("❎ 서버에서 메시지 로딩 실패: \(error)")
        }
    }
    
    // 입력한 메시지 서버에 post
    private func postMessageToServer() async {
        do {
            let messageInfo: PostMessages = PostMessages(
                roomID: roomID,
                contents: textMessage,
                files: []
            )
            Log.debug("채팅방ID: \(roomID)")
            let newMessage = try await chatRoomRepository.postNewMessage(messageInfo: messageInfo)
            messages.append(newMessage)
            
            textMessage = ""
        } catch {
            // TODO: 실패하면 서버에 전송이 안되기 때문에 DB에 저장하면 안되고, 재전송 버튼 보여야 함
            Log.error("❎ 메시지 포스트 실패: \(error)")
            // 전송이 실패해도 UI상 보여야 하기 때문에 하는 작업
            let newMessage = EachChatMessageEntity(
                chatID: "\(Date())",
                sender: .me,
                senderInfo: nil,
                sendStatus: .failed,
                content: textMessage,
                files: [],
                sendDate: Date().toISOString()
            )
            messages.append(newMessage)
            
            textMessage = ""
        }
    }
    
    // 실패한 메시지 서버에 재전송
    private func resendMessageToServer() async {
        do {
            let messageInfo: PostMessages = PostMessages(
                roomID: roomID,
                contents: resendMessage,
                files: []
            )
            
            let resendMessage = try await chatRoomRepository.postNewMessage(messageInfo: messageInfo)
            
            if let index = messages.firstIndex(where: {
                $0.content == resendMessage.content
            }) {
                messages[index] = resendMessage
            }
            
            Log.debug("🔗 메시지 재전송 성공")
            
        } catch {
            Log.error("❎ 메시지 재전송 실패")
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
    ChatRoomView(chatRoomRepository: DIContainer.shared.chatRoomRepository, roomID: "", opponentName: .constant("test"))
}

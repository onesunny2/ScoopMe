//
//  ChatRoomView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/17/25.
//

import SwiftUI
import RealmSwift
import SCMLogger

struct ChatRoomView: View {
    
    @State private var textMessage: String = ""
    @State private var sendStatus: Bool = false
    @FocusState private var focusBinding: Bool

    @ObservedResults(ChatRoom.self) var allChatRooms
    private
    var filteredChatRoom: ChatRoom? {
        allChatRooms.first(where: { $0.roomID == roomID })
    }
    
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
            if let chatRoom = filteredChatRoom {
                ForEach(chatRoom.messages, id: \.chatID) { message in
                    seperateSenderView(message: message)
                }
            }
        }
        .padding(.top, 12)
    }
    
    @ViewBuilder
    private func seperateSenderView(message: MessageRecord) -> some View {
        if message.isMine {
            MyChatBubbleCell(sendDate: message.createdAt, message: message.content, sendStatus: message.sendStatus) {
                Task {
                    await resendMessageToServer(chatID: message.chatID)
                }
            }
        } else {
            ReceivedChatBubbleCell(
                participant: filteredChatRoom?.participant ?? Participant(),
                sendDate: message.createdAt,
                message: message.content
            )
        }
    }
}

// MARK: Action
extension ChatRoomView {
    // message 호출
    @MainActor
    private func getServerMessages() async {
        do {
            let lastMessageAt = filteredChatRoom?.lastMessageAt
            let messageInfo = GetMessages(roomID: roomID, lastMessageDate: lastMessageAt ?? "")
//            Log.debug("현재 GetMessgaes: \(messageInfo)")
            try await chatRoomRepository.getChatMessages(roomID: roomID, messageInfo: messageInfo)
        } catch {
            Log.error("❎ 서버에서 메시지 로딩 실패: \(error)")
        }
    }
    
    // 입력한 메시지 서버에 post & DB 저장 과정
    @MainActor
    private func postMessageToServer() async {
        
        let messageType = MessageType.text.string
        let mediaType = MediaType()
        
        let tempMessage = MessageRecord(
            chatID: UUID().uuidString,
            isMine: true,
            content: textMessage,
            sendStatus: MessageSendStatus.sending.string,
            messageType: messageType,
            createdAt: Date().toKoreanDateString(),
            mediaType: (messageType == MessageType.text.string) ? nil : mediaType
        )
        
        do {
            try await chatRoomRepository.saveTempMessage(roomID: roomID, message: tempMessage)
            
            let messageInfo: PostMessages = PostMessages(
                roomID: roomID,
                contents: textMessage,
                files: []
            )
            try await chatRoomRepository.postNewMessage(roomID: roomID, messageInfo: messageInfo, temptID: tempMessage.chatID)
        } catch {
            Log.error("❎ 메시지 포스트 실패: \(error)")
            try? await chatRoomRepository.updateMessageStatus(
                roomID: roomID,
                chatID: tempMessage.chatID,
                status: MessageSendStatus.failed.string
            )
            
        }
        
        textMessage = ""
    }
    
    // 실패한 메시지 서버에 재전송
    private func resendMessageToServer(chatID: String) async {
        
        guard let failedMessage = filteredChatRoom?.messages.first(where: { $0.chatID == chatID }) else {
            Log.error("❎ 재전송 할 메시지가 존재하지 않습니다")
            return
        }
        
        do {
            let messageInfo: PostMessages = PostMessages(
                roomID: roomID,
                contents: failedMessage.content,
                files: []
            )
            try await chatRoomRepository.postNewMessage(roomID: roomID, messageInfo: messageInfo, temptID: chatID)
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

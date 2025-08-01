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
    
    @EnvironmentObject private var chatRoomTracker: ChatRoomTracker
    
    @State private var textMessage: String = ""
    @State private var sendStatus: Bool = false
    @FocusState private var focusBinding: Bool

    @ObservedResults(ChatRoom.self) var allChatRooms
    private
    var filteredChatRoom: ChatRoom? {
        allChatRooms.first(where: { $0.roomID == roomID })
    }
    
    private let chatRoomRepository: ChatRoomDisplayable
    private let socketChatManager: SocketChatDataSource
    private let notificationBadgeManager: BadgeService
    @Binding var roomID: String
    @Binding var opponentName: String
    
    init(
        chatRoomRepository: ChatRoomDisplayable,
        socketChatManager: SocketChatDataSource,
        notificationBadgeManager: BadgeService,
        roomID: Binding<String>,
        opponentName: Binding<String>
    ) {
        self.chatRoomRepository = chatRoomRepository
        self.socketChatManager = socketChatManager
        self.notificationBadgeManager = notificationBadgeManager
        self._roomID = roomID
        self._opponentName = opponentName
        
        Log.debug("현재 채팅방 roomID: \(roomID)")
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
            await notificationBadgeManager.clearBadgeCount(roomID: roomID)
        }
        .task {
            socketChatManager.configure(roomID: roomID)
            socketChatManager.onConnect = {
                Task {
                    await saveSocketMessageAtRealm()
                    await getServerMessages()
                }
            }
            socketChatManager.connect()
        }
        .onAppear {
            chatRoomTracker.enterChatRoom(room: roomID)
        }
        .onDisappear {
            chatRoomTracker.leaveChatRoom()
            socketChatManager.disconnect()
        }
    }
}

// MARK: UI
extension ChatRoomView {
    
    // 전체 내용 컨테이너 - VStack으로 변경하여 올바른 레이아웃 구성
    @ViewBuilder
    private var chatContainerView: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    messagesView
                        .padding(.bottom, 12)
                        .id(StringLiterals.scrollID.text)
                }
                .defaultHorizontalPadding()
                .onAppear {
                    scrollToBottom(proxy: proxy)
                }
                .onChange(of: sendStatus) { newStatus in
                    if newStatus {
                        Task {
                            try? await Task.sleep(for: .seconds(0.2))
                            scrollToBottom(proxy: proxy)
                        }
                    }
                }
            }
            
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
                    seperateSuccessSenderView(message: message)
                }
                
                ForEach(chatRoom.messages, id: \.chatID) { message in
                    failedSenderView(message: message)
                }
            }
        }
        .padding(.top, 12)
    }
    
    @ViewBuilder
    private func seperateSuccessSenderView(message: MessageRecord) -> some View {
        if message.isMine && message.sendStatus == MessageSendStatus.success.string {
            MyChatBubbleCell(
                sendDate: message.createdAt,
                message: message.content,
                sendStatus: message.sendStatus
            ) {
                Task {
                    await resendMessageToServer(chatID: message.chatID)
                }
            } onDeleteTapped: {
                Task {
                    await deleteMessageFromLocal(roomID: roomID, chatID: message.chatID)
                }
            }
        } else if !message.isMine && message.sendStatus == MessageSendStatus.success.string {
            ReceivedChatBubbleCell(
                participant: filteredChatRoom?.participant ?? Participant(),
                sendDate: message.createdAt,
                message: message.content
            ) {
                Task {
                    await deleteMessageFromLocal(roomID: roomID, chatID: message.chatID)
                }
            }
        }
    }
    
    @ViewBuilder
    private func failedSenderView(message: MessageRecord) -> some View {
        if message.isMine && message.sendStatus == MessageSendStatus.failed.string {
            MyChatBubbleCell(
                sendDate: message.createdAt,
                message: message.content,
                sendStatus: message.sendStatus
            ) {
                Task {
                    await resendMessageToServer(chatID: message.chatID)
                }
            } onDeleteTapped: {
                Task {
                    await deleteMessageFromLocal(roomID: roomID, chatID: message.chatID)
                }
            }
        }
    }
}

// MARK: Action
extension ChatRoomView {
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        proxy.scrollTo(StringLiterals.scrollID.text, anchor: .bottom)
    }
    
    // message 호출
    @MainActor
    private func getServerMessages() async {
        do {
            let lastReadMessageAt = filteredChatRoom?.lastReadMessageAt
            let messageInfo = GetMessages(roomID: roomID, lastMessageDate: lastReadMessageAt ?? "")
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
            try await chatRoomRepository.saveNewMessage(roomID: roomID, message: tempMessage)
            
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
    
    // 메시지 삭제
    private func deleteMessageFromLocal(roomID: String, chatID: String) async {
        do {
            try await chatRoomRepository.deleteMessage(roomID: roomID, chatID: chatID)
        } catch {
            Log.error("❎ 메시지 삭제 실패")
        }
    }
    
    // 소켓 통신으로 수신한 메시지 RealmDB에 저장
    private func saveSocketMessageAtRealm() async {
        socketChatManager.receiveMessage { message in
            do {
                let newMessage: MessageRecord = MessageRecord(
                    chatID: message["chat_id"] as! String,
                    isMine: false,
                    content: message["content"] as! String,
                    sendStatus: MessageSendStatus.success.string,
                    messageType: MessageType.text.string,
                    createdAt: message["createdAt"] as! String,
                    mediaType: nil
                )
                
                try await chatRoomRepository.saveNewMessage(roomID: roomID, message: newMessage)
            } catch {
                Log.error("❌ 소켓통신 메시지 저장 실패: \(error)")
            }
        }
    }
}

// MARK: StringLiterals
private enum StringLiterals: String {
    case messagePlaceholder = "메시지 입력"
    case scrollID = "bottom"
    
    var text: String {
        return self.rawValue
    }
}

#Preview {
    ChatRoomView(
        chatRoomRepository: DIContainer.shared.chatRoomRepository,
        socketChatManager: DIContainer.shared.socketChatManager,
        notificationBadgeManager: DIContainer.shared.notificationBadgeManager,
        roomID: .constant("test"),
        opponentName: .constant("test")
    )
}

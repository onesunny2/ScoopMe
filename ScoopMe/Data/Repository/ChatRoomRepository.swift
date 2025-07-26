//
//  ChatRoomRepository.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/16/25.
//

import Foundation
import SCMLogger
import SCMLogin
import SCMNetwork

final class ChatRoomRepository: ChatRoomDisplayable {
    
    let network: SCMNetworkImpl
    let loginTokenManager: LoginTokenManager
    
    private let chatDBRepository: SCMDataSource
    
    private var accessToken: String {
        return loginTokenManager.fetchToken(.accessToken)
    }
    
    init(
        chatDBRepo: SCMDataSource,
        loginTokenManager: LoginTokenManager
    ) {
        self.network = SCMNetworkImpl()
        self.chatDBRepository = chatDBRepo
        self.loginTokenManager = loginTokenManager
    }
    
    func fetchChatRoom(roomID: String) -> ChatRoom? {
        do {
            return try chatDBRepository.fetchChatRoom(roomID: roomID)
        } catch {
            return nil
        }
    }
    
    @MainActor
    func getChatMessages(roomID: String, messageInfo: GetMessages) async throws {
        
        let value = ChatURL.getMessages(access: accessToken, messageInfo: messageInfo)
        let result = try await callRequest(value, type: ChatListResponseDTO.self)
        let response = result.response.data
        
        Log.debug("새로 추가해야하는 메시지: \(response)")
        
        let myID = UserdefaultsValues.savedUserID.stringValue
        let messageType = MessageType.text.string
        let mediaType = MediaType()
        
        for message in response {
        
            let message = MessageRecord(
                chatID: message.chatID,
                isMine: (message.sender.userID == myID) ? true : false,
                content: message.content,
                sendStatus: MessageSendStatus.success.string,
                messageType: messageType,
                createdAt: message.createdAt,
                mediaType: (messageType == MessageType.text.string) ? nil : mediaType
            )
            
            try chatDBRepository.save(roomID: roomID, message)
        }
    }
    
    // 서버 전송 전 임시메시지 RealmDB 저장
    @MainActor
    func saveTempMessage(roomID: String, message: MessageRecord) async throws {
        try chatDBRepository.save(roomID: roomID, message)
    }
    
    // realm의 메시지 상태 업데이트
    @MainActor
    func updateMessageStatus(roomID: String, chatID: String, status: String) async throws {
        try chatDBRepository.updateMessageStatus(roomID: roomID, chatID: chatID, status: status)
    }
    
    // 서버에 post 함과 동시에, 성공하면 realm에 저장 > 실패하면 view에서 임시로 message 생성해서 realm에 저장 후 성공하면 전환
    @MainActor
    func postNewMessage(roomID: String, messageInfo: PostMessages, temptID: String) async throws {
        
        let value = ChatURL.postMessage(access: accessToken, messageInfo: messageInfo)
        let result = try await callRequest(value, type: ChatResponseDTO.self)
        let response = result.response

        let messageType = MessageType.text.string
        let mediaType = MediaType()
        
        let message = MessageRecord(
            chatID: response.chatID,
            isMine: true,
            content: response.content,
            sendStatus: MessageSendStatus.success.string,
            messageType: messageType,
            createdAt: response.createdAt,
            mediaType: (messageType == MessageType.text.string) ? nil : mediaType
        )
        
        try chatDBRepository.replaceMessage(roomID: roomID, tempID: temptID, newMessage: message)
    }
    
    @MainActor
    func deleteMessage(roomID: String, chatID: String) async throws {
        try chatDBRepository.deleteMessage(roomID: roomID, chatID: chatID)
    }
}

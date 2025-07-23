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
            return try chatDBRepository.fetch(roomID: roomID)
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
            
            entities.append(entity)
        }
        
        return entities
    }
    
    func postNewMessage(messageInfo: PostMessages) async throws -> EachChatMessageEntity {
        
        let value = ChatURL.postMessage(access: accessToken, messageInfo: messageInfo)
        let result = try await callRequest(value, type: ChatResponseDTO.self)
        let response = result.response
        
        let entity: EachChatMessageEntity = EachChatMessageEntity(
            chatID: response.chatID,
            sender: .me,
            senderInfo: SenderInfo(
                userID: response.sender.userID,
                nickname: response.sender.nick,
                profileURL: response.sender.profileImage
            ),
            sendStatus: .success,
            content: response.content,
            files: response.files,
            sendDate: response.createdAt
        )
        
        return entity
    }
}

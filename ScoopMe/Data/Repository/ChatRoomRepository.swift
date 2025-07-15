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
    
    private var accessToken: String {
        return loginTokenManager.fetchToken(.accessToken)
    }
    
    init() {
        self.network = SCMNetworkImpl()
        self.loginTokenManager = LoginTokenManager()
    }
    
    func getChatMessages(messageInfo: GetMessages) async throws -> [EachChatMessageEntity] {
        
        let value = ChatURL.getMessages(access: accessToken, messageInfo: messageInfo)
        let result = try await callRequest(value, type: ChatListResponseDTO.self)
        let response = result.response.data
        
        var entities: [EachChatMessageEntity] = []
        
        response.forEach {
            
            let myID = UserdefaultsValues.savedUserID.stringValue
            
            let entity = EachChatMessageEntity(
                chatID: $0.chatID,
                sender: ($0.sender.userID == myID) ? .me : .opponent,
                senderInfo: SenderInfo(
                    userID: $0.sender.userID,
                    nickname: $0.sender.nick,
                    profileURL: $0.sender.profileImage
                ),
                sendStatus: .success,
                content: $0.content,
                files: $0.files,
                sendDate: $0.createdAt
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

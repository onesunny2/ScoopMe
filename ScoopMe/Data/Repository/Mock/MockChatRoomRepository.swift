//
//  MockChatRoomRepository.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/16/25.
//

import Foundation
import SCMLogger
import SCMLogin
import SCMNetwork

final class MockChatRoomRepository: ChatRoomDisplayable {
    
    let network: SCMNetworkImpl
    let loginTokenManager: LoginTokenManager
    
    private var accessToken: String {
        return loginTokenManager.fetchToken(.accessToken)
    }
    
    init() {
        self.network = SCMNetworkImpl()
        self.loginTokenManager = LoginTokenManager()
    }
    
    func fetchChatRoom(roomID: String) -> ChatRoom? {
        return ChatRoom()
    }
    
    func getChatMessages(roomID: String, messageInfo: GetMessages) async throws {
        
    }
    
    func saveTempMessage(roomID: String, message: MessageRecord) async throws {
        
    }
    
    func updateMessageStatus(roomID: String, chatID: String, status: String) async throws {
        
    }
    
    func postNewMessage(roomID: String, messageInfo: PostMessages, temptID: String) async throws {
        let value = ChatURL.postMessage(access: accessToken, messageInfo: messageInfo)
        let result = try await callRequest(value, type: ChatResponseDTO.self)
        let response = result.response
    }
}

//
//  MockChatListRepository.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/16/25.
//

import Foundation
import SCMLogin
import SCMNetwork

final class MockChatListRepository: ChatListDisplayable {
    
    let network: SCMNetworkImpl
    let loginTokenManager: LoginTokenManager
    
    private var accessToken: String {
        return loginTokenManager.fetchToken(.accessToken)
    }
    
    init() {
        self.network = SCMNetworkImpl()
        self.loginTokenManager = LoginTokenManager()
    }
    
    func getChatroomID(opponent id: String) async throws -> String {
        return ""
    }
    
    func checkChatLists() async throws {
        
    }
}

extension MockChatListRepository {
    // 현재 채팅방이 존재하는지 확인
    private func checkChatRoom(opponent id: String) async throws -> Bool {
        
        let value = ChatURL.fetchChatRoom(access: accessToken, opponentUserid: id)
        let result = try await callRequest(value, type: ChatRoomResponseDTO.self)
        let lastChat = result.response.lastChat
        
        return lastChat != nil
    }
}

//
//  ChatListRepository.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/16/25.
//

import Foundation
import SCMLogin
import SCMNetwork

final class ChatListRepository: ChatListDisplayable {
    
    let network: SCMNetworkImpl
    let loginTokenManager: LoginTokenManager
    
    private var accessToken: String {
        return loginTokenManager.fetchToken(.accessToken)
    }
    
    private var myUserID: String {
        return UserdefaultsValues.savedUserID.stringValue
    }
    
    init() {
        self.network = SCMNetworkImpl()
        self.loginTokenManager = LoginTokenManager()
    }
    
    func getChatroomID(opponent id: String) async throws -> String {
        let value = ChatURL.fetchChatRoom(access: accessToken, opponentUserid: id)
        let result = try await callRequest(value, type: ChatRoomResponseDTO.self)
        
        return result.response.roomID
    }
    
    func getChatLists() async throws -> [ChatListItemEntity] {
        let value = ChatURL.loadChatRoom(access: accessToken)
        let result = try await callRequest(value, type: ChatRoomListResponseDTO.self)
        let response = result.response.data
        
        var entities: [ChatListItemEntity] = []
        
        response.forEach {
            
            let opponent = $0.participants.filter { $0.userID != myUserID }.first
            
            guard let opponent else { return }
            
            let entity = ChatListItemEntity(
                userID: opponent.userID,
                roomID: $0.roomID,
                profileImageURL: opponent.profileImage ?? "",
                username: opponent.nick,
                recentMessage: $0.lastChat?.content ?? "",
                recentTime: $0.updatedAt,
                messageCount: nil
            )
            
            entities.append(entity)
        }
        
        return entities
    }
}

//
//  ChatListRepository.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/16/25.
//

import Foundation
import RealmSwift
import SCMLogger
import SCMLogin
import SCMNetwork

final class ChatListRepository: ChatListDisplayable {
    
    let network: SCMNetworkImpl
    let loginTokenManager: LoginTokenManager
    
    private let chatDBRepository: SCMDataSource
    
    private var accessToken: String {
        return loginTokenManager.fetchToken(.accessToken)
    }
    
    private var myUserID: String {
        return UserdefaultsValues.savedUserID.stringValue
    }
    
    init(chatDBRepo: SCMDataSource, loginTokenManager: LoginTokenManager) {
        self.network = SCMNetworkImpl()
        self.chatDBRepository = chatDBRepo
        self.loginTokenManager = loginTokenManager
    }
    
    func getChatroomID(opponent id: String) async throws -> String {
        let value = ChatURL.fetchChatRoom(access: accessToken, opponentUserid: id)
        let result = try await callRequest(value, type: ChatRoomResponseDTO.self)
        
        return result.response.roomID
    }
    
    @MainActor
    func checkChatLists() async throws {
        let value = ChatURL.loadChatRoom(access: accessToken)
        let result = try await callRequest(value, type: ChatRoomListResponseDTO.self)
        let response = result.response.data
        
        response.forEach {
            
            let opponent = $0.participants.filter { $0.userID != myUserID }.first
            guard let opponent else { return }
            
            let chatRoom = ChatRoom(
                roomID: $0.roomID,
                createdAt: $0.createdAt,
                lastMessageAt: $0.updatedAt,
                lastMessageContent: $0.lastChat?.content ?? "",
                isActive: true,
                unreadCount: nil
            )
            
            let participant = Participant(
                userID: opponent.userID,
                nickname: opponent.nick,
                profileImage: opponent.profileImage ?? "",
                isActive: true
            )
            
            chatRoom.participant.append(participant)
            
            do {
                try chatDBRepository.create(chatRoom: chatRoom)
            } catch {
                Log.error("❎ 채팅방 목록 로컬DB 저장 실패: \(error)")
            }
        }
    }
}

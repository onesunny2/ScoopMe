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
        
        for chatData in response {
            let opponent = chatData.participants.filter { $0.userID != myUserID }.first
            guard let opponent else { continue }
            
            let chatRoom = ChatRoom(
                roomID: chatData.roomID,
                createdAt: chatData.createdAt,
                lastMessageAt: chatData.updatedAt,
                lastMessageContent: chatData.lastChat?.content ?? "",
                isActive: true,
                unreadCount: nil
            )
            
            let isUserActive = await checkExistingUser(opponent.nick)
            
            let mainUser = await fetchMainUser()
            chatRoom.mainUser = mainUser
            
            let participant: Participant = Participant(
                userID: opponent.userID,
                nickname: opponent.nick,
                profileImage: opponent.profileImage ?? "",
                isActive: isUserActive
            )
            chatRoom.participant = participant
            
            do {
                // 기존에 저장된 chatRoom 있는지 확인
                let existingChatRoom = try chatDBRepository.fetch(roomID: chatData.roomID)
                
                if shouldUpdateNeeded(existing: existingChatRoom, new: chatRoom) {
                    try chatDBRepository.create(chatRoom: chatRoom)
                } else {
                    Log.debug("🔗 이미 생성된 채팅방 존재")
                }
                
            } catch SCMRealmError.roomNotFound {
                try chatDBRepository.create(chatRoom: chatRoom)
                Log.info("✅ 새로운 채팅방 생성")
            } catch {
                Log.error("❎ 채팅방 목록 로컬DB 저장 실패: \(error)")
            }
        }
    }
}

extension ChatListRepository {
    // 존재하는 유저인지 확인
    private func checkExistingUser(_ nick: String) async -> Bool {
        do {
            let value = ChatURL.checkUserExisted(access: accessToken, nickname: nick)
            let result = try await callRequest(value, type: UserInfoListResponseDTO.self)
            let response = result.response.data
            
            return !response.isEmpty
        } catch {
            Log.error("❎ 해당 닉네임의 유저가 존재하지 않습니다: \(error)")
            return false
        }
    }
    
    // 현재 내 프로필 확인
    private func fetchMainUser() async -> MainUser {
        do {
            let value = ChatURL.fetchMainUser(access: accessToken)
            let result = try await callRequest(value, type: MyInfoResponseDTO.self)
            let response = result.response
            
            let user: MainUser = MainUser(
                userID: response.user_id,
                nickname: response.nick,
                profileImage: response.profileImage
            )
            
            return user
        } catch {
            Log.error("❎ 유저 정보 획득에 실패했습니다: \(error)")
            let user = MainUser()
            return user
        }
    }
    
    // 업데이트가 필요한지 chatRoom 확인
    private func shouldUpdateNeeded(existing: ChatRoom, new: ChatRoom) -> Bool {
        
        if existing.lastMessageAt != new.lastMessageAt { return true }
        if existing.lastMessageContent != new.lastMessageContent { return true }
        
        if let existingMainUser = existing.mainUser, let newMainUser = new.mainUser {
            if existingMainUser.nickname != newMainUser.nickname || existingMainUser.profileImage != newMainUser.profileImage {
                return true
            }
        }
        
        if let existingParticipant = existing.participant, let newParticipant = new.participant {
            if existingParticipant.nickname != newParticipant.nickname || existingParticipant.profileImage != newParticipant.profileImage || existingParticipant.isActive != newParticipant.isActive {
                return true
            }
        }
        
        if existing.isActive != new.isActive { return true }
        
        return false
    }
}

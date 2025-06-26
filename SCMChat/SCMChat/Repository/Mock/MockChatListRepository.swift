//
//  MockChatListRepository.swift
//  SCMChat
//
//  Created by Lee Wonsun on 6/26/25.
//

import Foundation
import SCMLogin
import SCMNetwork

public final class MockChatListRepository: ChatListDisplayable {
    
    public let network: SCMNetworkImpl
    public let loginTokenManager: LoginTokenManager
    
    public init() {
        self.network = SCMNetworkImpl()
        self.loginTokenManager = LoginTokenManager()
    }
    
    public func getChatLists() async throws -> [ChatListItemEntity] {
        
        let entities: [ChatListItemEntity] = [
            ChatListItemEntity(
                userID: "1",
                roomID: "",
                profileImageURL: Secret.baseURL + "/v1/data/stores/alan-hardman-SU1LFoeEUkk-unsplash_1747128644203.jpg",
                username: "이짜몽",
                recentMessage: "왜 짜몽이는 항상 사람이 있어야 밥을 먹을까?",
                recentTime: "오후 3:37",
                messageCount: nil
            ),
            ChatListItemEntity(
                userID: "2",
                roomID: "",
                profileImageURL: Secret.baseURL + "/v1/data/stores/alan-hardman-SU1LFoeEUkk-unsplash_1747128644203.jpg",
                username: "이원선",
                recentMessage: "도레미파솔라시도도도도 토토토톡 오늘 저녁은 샐러드 파스타? 아니면 밥으로 먹을까?",
                recentTime: "오후 1:21",
                messageCount: 2
            ),
            ChatListItemEntity(
                userID: "3",
                roomID: "",
                profileImageURL: Secret.baseURL + "/v1/data/stores/alan-hardman-SU1LFoeEUkk-unsplash_1747128644203.jpg",
                username: "마망💛",
                recentMessage: "엄마 들어오면서 메로나 하나만~.~",
                recentTime: "오전 9:37",
                messageCount: 1
            ),
            ChatListItemEntity(
                userID: "4",
                roomID: "",
                profileImageURL: Secret.baseURL + "/v1/data/stores/alan-hardman-SU1LFoeEUkk-unsplash_1747128644203.jpg",
                username: "오빠",
                recentMessage: "???",
                recentTime: "6월 25일",
                messageCount: nil
            )
        ]
        
        return entities
    }
}

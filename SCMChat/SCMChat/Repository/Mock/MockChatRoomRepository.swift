//
//  MockChatRoomRepository.swift
//  SCMChat
//
//  Created by Lee Wonsun on 6/30/25.
//

import Foundation
import SCMLogger
import SCMLogin
import SCMNetwork

public final class MockChatRoomRepository: ChatRoomDisplayable {
    
    public let network: SCMNetworkImpl
    public let loginTokenManager: LoginTokenManager
    
    private var accessToken: String {
        return loginTokenManager.fetchToken(.accessToken)
    }
    
    public init() {
        self.network = SCMNetworkImpl()
        self.loginTokenManager = LoginTokenManager()
    }
    
    public func getChatMessages(messageInfo: GetMessages) async throws -> [EachChatMessageEntity] {
        
        let messages: [EachChatMessageEntity] = [
            EachChatMessageEntity(
                chatID: "1",
                sender: .me,
                senderInfo: nil,
                sendStatus: .success,
                content: "안녕하세요 :)",
                files: [],
                sendDate: ""
            ),
            EachChatMessageEntity(
                chatID: "2",
                sender: .opponent,
                senderInfo: SenderInfo(
                    userID: "asdf",
                    nickname: "이짜몽",
                    profileURL: nil
                ),
                sendStatus: .success,
                content: "네 안녕하세요! 어떻게 연락주셨나요?",
                files: [],
                sendDate: ""
            ),
            EachChatMessageEntity(
                chatID: "3",
                sender: .me,
                senderInfo: nil,
                sendStatus: .success,
                content: "다름 아니라 스쿱통에 보내주신 포스트 보고 연락드렸습니다!! 여쭤보고 싶은게 있어서요!",
                files: [],
                sendDate: ""
            ),
            EachChatMessageEntity(
                chatID: "4",
                sender: .me,
                senderInfo: nil,
                sendStatus: .success,
                content: "요기 카페 장소가 넓었는지 궁금해서 메시지 드렸어요!\n모임을 하려고 하는데, 장소가 협소할까봐...ㅎㅎ",
                files: [],
                sendDate: ""
            ),
            EachChatMessageEntity(
                chatID: "5",
                sender: .opponent,
                senderInfo: SenderInfo(
                    userID: "asdf",
                    nickname: "이짜몽",
                    profileURL: nil
                ),
                sendStatus: .success,
                content: "아하! 그러면 걱정 하세요! 한번에 8명까지는 수용 가능할 것 같아용",
                files: [],
                sendDate: ""
            ),
            EachChatMessageEntity(
                chatID: "6",
                sender: .me,
                senderInfo: nil,
                sendStatus: .success,
                content: "감사합니다!!! 좋은 하루 되세요 :>",
                files: [],
                sendDate: ""
            ),
            EachChatMessageEntity(
                chatID: "7",
                sender: .opponent,
                senderInfo: SenderInfo(
                    userID: "asdf",
                    nickname: "이짜몽",
                    profileURL: nil
                ),
                sendStatus: .success,
                content: "네에! 좋은 하루 되세요~~",
                files: [],
                sendDate: ""
            )
        ]
        
        return messages
    }

    public func postNewMessage(messageInfo: PostMessages) async throws -> EachChatMessageEntity {
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

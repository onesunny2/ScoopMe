//
//  ChatRoomRepository.swift
//  SCMChat
//
//  Created by Lee Wonsun on 6/19/25.
//

import Foundation
import SCMLogger
import SCMLogin
import SCMNetwork

public final class ChatRoomRepository: ChatRoomDisplayable {
    
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

//public final class ChatRoomRepository {
//    private var manager: SocketManager
//    private var socket: SocketIOClient
//    
//    private let roomID: String
//    private var accessToken: String
//    
//    public let loginTokenManager: LoginTokenManager
//    public let network: SCMNetworkImpl
//    
//    public init(roomID: String) {
//        
//        self.loginTokenManager = LoginTokenManager()
//        self.network = SCMNetworkImpl()
//        
//        // socketURL 연결
//        self.roomID = roomID
//        self.accessToken = loginTokenManager.fetchToken(.accessToken)
//        let socketURL = "http://" + Secret.baseURL + "/chats-\(roomID)"
//        self.manager = SocketManager(
//            socketURL: URL(string: socketURL)!,
//            config: [
//                .log(true),
//                .compress,
//                .forceWebsockets(true),
//                .extraHeaders([
//                    "SeSACKey": Secret.apiKey,
//                    "Authorization": self.accessToken
//                ])
//            ]
//        )
//        self.socket = manager.defaultSocket
//        
//        setupSocketEvents()
//    }
//    
//    // 소켓 연결, 해제 메서드
//    public func connect() {
//        socket.connect()
//    }
//    
//    public func disconnect() {
//        socket.disconnect()
//    }
//}
//
//// MARK: Action
//extension ChatRoomRepository {
//    
//    // 소켓 세팅
//    private func setupSocketEvents() {
//        socket.on(clientEvent: .connect) { [weak self] data, ack in
//            guard let self else { return }
//            
//            Log.debug("🔗 Socket connected", data, ack)
//        }
//        
//        socket.on(clientEvent: .disconnect) { [weak self] data, ack in
//            guard let self else { return }
//            
//            Log.debug("🔗 Socket disconnected", data, ack)
//        }
//        
//        socket.on("chat") { [weak self] dataArray, ack in
//            guard let self else { return }
//            
//            Log.debug("🔗 chat received", dataArray, ack)
//        }
//    }
//}

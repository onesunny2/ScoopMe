//
//  ChatRoomRepository.swift
//  SCMChat
//
//  Created by Lee Wonsun on 6/19/25.
//

import Foundation
internal import SocketIO
import SCMLogger
import SCMLogin
import SCMNetwork

public final class ChatRoomRepository {
    private var manager: SocketManager
    private var socket: SocketIOClient
    
    private let roomID: String
    private var accessToken: String
    
    public let loginTokenManager: LoginTokenManager
    public let network: SCMNetworkImpl
    
    public init(roomID: String) {
        
        self.loginTokenManager = LoginTokenManager()
        self.network = SCMNetworkImpl()
        
        // socketURL 연결
        self.roomID = roomID
        self.accessToken = loginTokenManager.fetchToken(.accessToken)
        let socketURL = "http://" + Secret.baseURL + "/chats-\(roomID)"
        self.manager = SocketManager(
            socketURL: URL(string: socketURL)!,
            config: [
                .log(true),
                .compress,
                .forceWebsockets(true),
                .extraHeaders([
                    "SeSACKey": Secret.apiKey,
                    "Authorization": self.accessToken
                ])
            ]
        )
        self.socket = manager.defaultSocket
        
        setupSocketEvents()
    }
    
    // 소켓 연결, 해제 메서드
    public func connect() {
        socket.connect()
    }
    
    public func disconnect() {
        socket.disconnect()
    }
}

// MARK: Action
extension ChatRoomRepository {
    
    // 소켓 세팅
    private func setupSocketEvents() {
        socket.on(clientEvent: .connect) { [weak self] data, ack in
            guard let self else { return }
            
            Log.debug("🔗 Socket connected", data, ack)
        }
        
        socket.on(clientEvent: .disconnect) { [weak self] data, ack in
            guard let self else { return }
            
            Log.debug("🔗 Socket disconnected", data, ack)
        }
        
        socket.on("chat") { [weak self] dataArray, ack in
            guard let self else { return }
            
            Log.debug("🔗 chat received", dataArray, ack)
        }
    }
}

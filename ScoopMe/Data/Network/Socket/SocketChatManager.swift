//
//  SocketChatManager.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/23/25.
//

import Foundation
import SocketIO
import SCMLogger
import SCMLogin

final class SocketChatManager: SocketChatDataSource {
    private var roomID: String?
    private let loginTokenManager: LoginTokenManager
    private var socketManager: SocketManager?
    private var socket: SocketIOClient?
    
    var onConnect: (() -> Void)?
    
    init(loginTokenManager: LoginTokenManager) {
        self.loginTokenManager = loginTokenManager
    }
    
    func configure(roomID: String) {
        self.roomID = roomID
        
        let url = "http://" + Secret.baseURL + "/chats-\(roomID)"
        let accessToken = loginTokenManager.fetchToken(.accessToken)
        
        self.socketManager = SocketManager(
            socketURL: URL(string: url)!,
            config: [
                .log(true),
                .compress,
                .extraHeaders(["Authorization": accessToken, "SeSACKey": Secret.apiKey])
            ]
        )
        self.socket = socketManager?.defaultSocket
    }
    
    func connect() {
        guard let socket else {
            Log.error("❌ Socket Configure가 호출되지 않았습니다")
            return
        }
        socket.connect()
        
        // 연결 성공 시 이벤트처리
        socket.on(clientEvent: .connect) { [weak self] data, ack in
            guard let self else { return }
            Log.debug("🔗 소켓연결", data, ack)
            self.onConnect?()
        }
        
        // 연결 실패 시 이벤트처리
        socket.on(clientEvent: .error) { data, ack in
            Log.debug("❌ 소켓연결오류", data, ack)
        }
        
        // 연결 해제 시 이벤트처리
        socket.on(clientEvent: .disconnect) { data, ack in
            Log.debug("🔗 소켓연결해제", data, ack)
        }
    }
    
    func disconnect() {
        socket?.disconnect()
        onConnect = nil
    }
    
    func receiveMessage() {
        socket?.on("chat") { [weak self] data, ack in
            guard let self else { return }
            
            if let messageData = data.first as? [String: Any] {
                Log.debug("메시지 수신: \(messageData)")
            }
//            do {
//                if let messageData = data.first as? [String: Any] {
//                    Log.debug("메시지 수신: \(messageData)")
//                }
//            } catch {
//                Log.error("❌ 메시지 수신 오류")
//            }
        }
    }
    
    func sendMessage(content: [String: Any]) {
        Log.debug("메시지 전송: \(content)")
        
        socket?.emit("chat", content)
    }
}

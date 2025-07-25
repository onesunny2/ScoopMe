//
//  SocketChatDataSource.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/23/25.
//

import Foundation

protocol SocketChatDataSource: AnyObject {
    func configure(roomID: String)
    func connect()
    func disconnect()
    func receiveMessage()
    func sendMessage(content: [String: Any])
}

//
//  ChatRepository.swift
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
    
    public let loginTokenManager: LoginTokenManager
    public let network: SCMNetworkImpl
    
    private var accessToken: String {
        return loginTokenManager.fetchToken(.accessToken)
    }
    
    public init() {
        self.loginTokenManager = LoginTokenManager()
        self.network = SCMNetworkImpl()
    }
    
    //
}

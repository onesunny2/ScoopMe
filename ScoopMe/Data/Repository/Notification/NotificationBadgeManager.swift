//
//  NotificationBadgeManager.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/31/25.
//

import Foundation

final class NotificationBadgeManager: BadgeService {
    
    private let chatDBRepository: SCMDataSource
    
    init(chatDBRepository: SCMDataSource) {
        self.chatDBRepository = chatDBRepository
    }
    
    func addBadgeCount(roomID: String) {
        chatDBRepository.addMessageCount(roomID: roomID)
    }
    
    func clearBadgeCount(roomID: String) async {
        chatDBRepository.clearMessageCount(roomID: roomID)
    }
}

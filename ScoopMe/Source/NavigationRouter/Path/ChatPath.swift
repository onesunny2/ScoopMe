//
//  ChatPath.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 6/30/25.
//

import Foundation
import SCMChat

enum ChatPath: Hashable {
    case chatRoom(roomID: String, opponentName: String)
}

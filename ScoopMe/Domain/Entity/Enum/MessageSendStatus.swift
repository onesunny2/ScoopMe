//
//  MessageSendStatus.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/16/25.
//

import Foundation

enum MessageSendStatus: String {
    case sending
    case success
    case failed
    
    var string: String {
        return self.rawValue
    }
}

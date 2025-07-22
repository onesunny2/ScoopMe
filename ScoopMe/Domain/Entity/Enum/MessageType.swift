//
//  MessageType.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/21/25.
//

import Foundation

enum MessageType: String {
    case text
    case photo
    
    var string: String {
        return self.rawValue
    }
}

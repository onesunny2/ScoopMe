//
//  EmailDuplication.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/13/25.
//

import Foundation

enum EmailDuplication {
    case title
    case message(String)
    
    var string: String {
        switch self {
        case .title:
            return "중복 확인"
        case .message(let message):
            return message
        }
    }
}

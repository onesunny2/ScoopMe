//
//  ToastMessage.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 6/3/25.
//

import SwiftUI

struct ToastMessage {
    let text: String
    let type: ToastType
    
    enum ToastType {
        case success
        
        var icon: Image {
            return Image(.sesac)
        }
        
        var color: Color {
            return .scmBlackSprout
        }
    }
}

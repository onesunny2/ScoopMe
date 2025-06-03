//
//  ToastView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 6/3/25.
//

import SwiftUI

struct ToastView: View {
    
    @Binding var isShowing: Bool
    let message: ToastMessage
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            message.type.icon
                .basicImage(width: 20, color: .scmBrightForsythia)
            
            Text(message.text)
                .basicText(.PTBody2, message.type.color)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.scmGray75.opacity(0.5))
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(message.type.color, lineWidth: 1)
                )
        )
        .defaultHorizontalPadding()
        .offset(y: isShowing ? 0 : -100)
        .opacity(isShowing ? 1 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isShowing)
    }
}

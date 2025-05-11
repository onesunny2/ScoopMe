//
//  BackButtonModifier.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/11/25.
//

import SwiftUI

struct BackButtonModifier<S: ShapeStyle>: ViewModifier {
    
    @Environment(\.dismiss) private var dismiss
    
    let color: S
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(.chevron)
                            .basicImage(width: 40, color: color)
                    }
                }
            }
    }
}

extension View {
    func backButton<S: ShapeStyle>(_ color: S) -> some View {
        modifier(BackButtonModifier(color: color))
    }
}

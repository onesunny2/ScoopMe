//
//  PlaceHolderModifier.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/10/25.
//

import SwiftUI

struct PlaceHolderModifier: ViewModifier {
    
    let placeholder: String
    @Binding var text: String
    let padding: CGFloat
    
    func body(content: Content) -> some View {
        
        content
            .overlay(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .basicText(.PTBody2, .scmGray60)
                        .padding(.leading, padding)
                }
            }
    }
}

extension View {
    func placeholder(_ holder: String, _ text: Binding<String>, _ padding: CGFloat = 0.0) -> some View {
        modifier(PlaceHolderModifier(placeholder: holder, text: text, padding: padding))
    }
}

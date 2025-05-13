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
    
    func body(content: Content) -> some View {
        
        content
            .overlay(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .basicText(.PTBody1, .scmGray60)
                }
            }
    }
}

extension View {
    func placeholder(_ holder: String, _ text: Binding<String>) -> some View {
        modifier(PlaceHolderModifier(placeholder: holder, text: text))
    }
}

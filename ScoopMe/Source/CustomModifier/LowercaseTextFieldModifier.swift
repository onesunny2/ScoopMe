//
//  LowercaseTextFieldModifier.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/14/25.
//

import SwiftUI

struct LowercaseTextFieldModifier: ViewModifier {
    
    @Binding var text: String
    
    func body(content: Content) -> some View {
        content
            .onChange(of: text) { newText in
                if newText != newText.lowercased() {
                    text = newText.lowercased()
                }
            }
    }
}

extension View {
    func lowercaseTextfield(_ text: Binding<String>) -> some View {
        modifier(LowercaseTextFieldModifier(text: text))
    }
}

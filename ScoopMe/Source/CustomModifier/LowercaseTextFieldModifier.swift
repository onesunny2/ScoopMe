//
//  LowercaseTextFieldModifier.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/14/25.
//

import SwiftUI

struct LowercaseTextFieldModifier: ViewModifier {
    
    @Binding var text: String
    let resetStatus: () -> ()?
    
    func body(content: Content) -> some View {
        content
            .onChange(of: text) { newText in
                if newText != newText.lowercased() {
                    text = newText.lowercased()
                }
                
                if newText.contains(" ") {
                    text = newText.replacingOccurrences(of: " ", with: "")
                }
                
                resetStatus()
            }
    }
}

extension View {
    func lowercaseTextfield(_ text: Binding<String>, reset status: @escaping () -> ()) -> some View {
        modifier(LowercaseTextFieldModifier(text: text, resetStatus: status))
    }
}

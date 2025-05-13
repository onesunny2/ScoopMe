//
//  ButtonModifier.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/11/25.
//

import SwiftUI

struct ButtonModifier: ViewModifier {
    
    let action: () -> ()
    let isDisabled: Bool
    
    func body(content: Content) -> some View {
        Button {
            action()
        } label: {
            content
        }
        .disabled(isDisabled)
    }
}

extension View {
    func asButton(_ action: @escaping () -> (), disabled: Bool = false) -> some View {
        modifier(ButtonModifier(action: action, isDisabled: disabled))
    }
}

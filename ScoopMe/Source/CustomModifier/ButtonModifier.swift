//
//  ButtonModifier.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/11/25.
//

import SwiftUI

struct ButtonModifier: ViewModifier {
    
    let action: () -> ()
    
    func body(content: Content) -> some View {
        Button {
            action()
        } label: {
            content
        }

    }
}

extension View {
    func asButton(_ action: @escaping () -> ()) -> some View {
        modifier(ButtonModifier(action: action))
    }
}

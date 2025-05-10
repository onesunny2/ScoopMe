//
//  DefaultHorizontalPaddingModifier.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/10/25.
//

import SwiftUI

struct DefaultHorizontalPaddingModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
    }
}

extension View {
    func defaultHorizontalPadding() -> some View {
        modifier(DefaultHorizontalPaddingModifier())
    }
}

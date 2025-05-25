//
//  UnevenRectangleClipModifier.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/21/25.
//

import SwiftUI

struct UnevenRectangleClipModifier: ViewModifier {
    
    let topLeading: CGFloat
    let bottomLeading: CGFloat
    let bottomTrailing: CGFloat
    let topTrailing: CGFloat
    
    func body(content: Content) -> some View {
        content
            .clipShape(
                unevenRectangle
            )
            .contentShape(unevenRectangle)
    }
    
    private var unevenRectangle: UnevenRoundedRectangle {
        UnevenRoundedRectangle(
            topLeadingRadius: topLeading,
            bottomLeadingRadius: bottomLeading,
            bottomTrailingRadius: bottomTrailing,
            topTrailingRadius: topTrailing
        )
    }
}

extension View {
    func clippedUnevenRectangle(
        _ topLeading: CGFloat,
        _ bottomLeading: CGFloat,
        _ bottomTrailing: CGFloat,
        _ topTrailing: CGFloat
    ) -> some View {
        modifier(
            UnevenRectangleClipModifier(
                topLeading: topLeading,
                bottomLeading: bottomLeading,
                bottomTrailing: bottomTrailing,
                topTrailing: topTrailing
            )
        )
    }
}

//
//  StrokeRoundBackgroundModifier.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/26/25.
//

import SwiftUI

struct StrokeRoundBackgroundModifier<S: ShapeStyle>: ViewModifier {
    
    let fillColor: S
    let strokeColor: S
    let lineWidth: CGFloat
    let radius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background {
                RoundedRectangle(cornerRadius: radius)
                    .fill(fillColor)
                    .overlay {
                        RoundedRectangle(cornerRadius: radius)
                            .stroke(strokeColor, lineWidth: lineWidth)
                    }
            }
    }
}

extension View {
    func strokeRoundBackground<S: ShapeStyle>(_ fillColor: S, _ strokeColor: S, _ lineWidth: CGFloat, _ radius: CGFloat) -> some View {
        modifier(StrokeRoundBackgroundModifier(fillColor: fillColor, strokeColor: strokeColor, lineWidth: lineWidth, radius: radius))
    }
}

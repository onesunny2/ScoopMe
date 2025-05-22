//
//  TagBadgeModifier.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/22/25.
//

import SwiftUI

struct TagBadgeModifier<S: ShapeStyle>: ViewModifier {
    
    let bgColor: S
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .fill(bgColor)
            }
    }
}

extension View {
    func tagBadge<S: ShapeStyle>(_ bg: S) -> some View {
        modifier(TagBadgeModifier(bgColor: bg))
    }
}

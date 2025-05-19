//
//  ToolbarItemModifier.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/19/25.
//

import SwiftUI

struct ToolbarItemModifier<LeadingContent: View, TrailingContent: View>: ViewModifier {
    
    let leadingContent: (() -> LeadingContent)
    let trailingContent: (() -> TrailingContent)
    
    init(
        @ViewBuilder leadingContent: @escaping () -> LeadingContent = { EmptyView() },
        @ViewBuilder trailingContent: @escaping () -> TrailingContent = { EmptyView() }
    ) {
        self.leadingContent = leadingContent
        self.trailingContent = trailingContent
    }
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                if !(leadingContent() is EmptyView) {
                    ToolbarItem(placement: .topBarLeading) {
                        leadingContent()
                    }
                }
                
                if !(trailingContent() is EmptyView) {
                    ToolbarItem(placement: .topBarTrailing) {
                        trailingContent()
                    }
                }
            }
    }
}

extension View {
    func toolbarItem<LeadingContent: View, TrailingContent: View>(
        @ViewBuilder leading: @escaping () -> LeadingContent = { EmptyView() },
        @ViewBuilder trailing: @escaping () -> TrailingContent = { EmptyView() }
    ) -> some View {
        modifier(ToolbarItemModifier(leadingContent: leading, trailingContent: trailing))
    }
}

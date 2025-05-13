//
//  NavigationRightItemButtonModifier.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/13/25.
//

import SwiftUI

struct NavigationRightItemButtonModifier<ToolbarContent: View>: ViewModifier {
    
    let toolbarContent: () -> ToolbarContent
    
    init(@ViewBuilder toolbarContent: @escaping () -> ToolbarContent) {
        self.toolbarContent = toolbarContent
    }
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    toolbarContent()
                }
            }
    }
}

extension View {
    func navigationRightItem<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        modifier(NavigationRightItemButtonModifier(toolbarContent: content))
    }
}

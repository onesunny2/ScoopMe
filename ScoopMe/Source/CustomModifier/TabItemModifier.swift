//
//  TabItemModifier.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/17/25.
//

import SwiftUI

struct TabItemModifier: ViewModifier {
    
    let image: Image
    
    func body(content: Content) -> some View {
        content
            .tabItem {
                image
            }
    }
}

extension View {
    func tabImage(_ image: Image) -> some View {
        modifier(TabItemModifier(image: image))
    }
}

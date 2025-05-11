//
//  Text+.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/10/25.
//

import SwiftUI

extension Text {
    
    func basicText<S: ShapeStyle>(_ font: Font, _ color: S) -> some View {
        self
            .font(font)
            .foregroundStyle(color)
    }
}

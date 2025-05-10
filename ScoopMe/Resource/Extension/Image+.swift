//
//  Image+.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/10/25.
//

import SwiftUI

extension Image {
    
    // 일반 이미지
    func basicImage(_ mode: ContentMode = .fit, width: CGFloat? = nil, height: CGFloat? = nil) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: mode)
            .frame(width: width, height: height)
    }
    
    // 심볼 이미지
    func basicImage<S: ShapeStyle>(_ mode: ContentMode = .fit, width: CGFloat? = nil, height: CGFloat? = nil, color: S) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: mode)
            .frame(width: width, height: height)
            .foregroundStyle(color)
    }
}

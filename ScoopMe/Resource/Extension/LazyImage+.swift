//
//  LazyImage+.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/20/25.
//

import SwiftUI
import NukeUI

extension LazyImage<Image> {
    
    func basicImage(_ mode: ContentMode = .fit, width: CGFloat? = nil, height: CGFloat? = nil) -> some View {
        self
            .aspectRatio(contentMode: mode)
            .frame(width: width, height: height)
    }
}

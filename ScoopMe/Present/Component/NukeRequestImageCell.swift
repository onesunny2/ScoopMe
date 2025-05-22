//
//  NukeRequestImageCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/21/25.
//

import SwiftUI
import Nuke
import NukeUI
import SCMImageRequest
import SCMLogger

struct NukeRequestImageCell: View {
    
    let imageHelper: ImageHelper
    let url: String
    let topLeading: CGFloat
    let bottomLeading: CGFloat
    let bottomTrailing: CGFloat
    let topTrailing: CGFloat
    
    var body: some View {
        if let request = imageHelper.createImageRequest(image: url) {
            LazyImage(request: request) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else if (state.error) != nil {
                    unevenRectangle
                        .fill(.scmBrightForsythia)
                } else {
                    ProgressView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        } else {
            unevenRectangle
                .fill(.scmBrightForsythia)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
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

#Preview {
    NukeRequestImageCell(
        imageHelper: DIContainer.shared.imageHelper,
        url: "/v1/data/stores/jeremy-yap-jn-HaGWe4yw-unsplash_1747128572373.jpg",
        topLeading: 10,
        bottomLeading: 10,
        bottomTrailing: 10,
        topTrailing: 10
    )
}

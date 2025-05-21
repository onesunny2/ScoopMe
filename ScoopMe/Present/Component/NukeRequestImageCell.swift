//
//  NukeRequestImageCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/21/25.
//

import SwiftUI
import NukeUI
import SCMImageRequest
import SCMLogger

struct NukeRequestImageCell: View {
    
    let imageHelper: ImageHelper
    let likeStatus: Bool
    let picchelinStatus: Bool
    let url: String
    let topLeading: CGFloat
    let bottomLeading: CGFloat
    let bottomTrailing: CGFloat
    let topTrailing: CGFloat
    let width: CGFloat
    let height: CGFloat
    
    var likeButtonAction: () -> Void
    
    var body: some View {
        if let request = imageHelper.createImageRequest(image: url) {
            LazyImage(request: request) { state in
                if let image = state.image {
                    image
                        .basicImage(.fill, width: width, height: height)
                        .clipShape(
                            unevenRectangle
                        )
                        .overlay(alignment: .topLeading) {
                            badges()
                        }
                } else if (state.error) != nil {
                    unevenRectangle
                    .fill(.scmBrightForsythia)
                } else {
                    ProgressView()
                }
            }
            .frame(width: width, height: height)
        } else {
            unevenRectangle
            .fill(.scmBrightForsythia)
            .frame(width: width, height: height)
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
    
    private func badges() -> some View {
        
        HStack(alignment: .center) {
            Image(likeStatus ? .likeFill : .likeEmpty)
                .basicImage(width: 24, color: likeStatus ? .scmBlackSprout : .scmGray45)
                .padding([.top, .leading], 5)
                .asButton {
                    likeButtonAction()
                }
            
            Spacer()
            
            PickBadgeCell()
                .opacity(picchelinStatus ? 1 : 0)
        }
    }
}

#Preview {
    NukeRequestImageCell(
        imageHelper: DIContainer.shared.imageHelper,
        likeStatus: true,
        picchelinStatus: false,
        url: "/v1/data/stores/jeremy-yap-jn-HaGWe4yw-unsplash_1747128572373.jpg",
        topLeading: 10,
        bottomLeading: 10,
        bottomTrailing: 10,
        topTrailing: 10,
        width: 200,
        height: 200
    ) {
        Log.debug("좋아요 버튼 클릭 - 나중에 서버연결 해야함")
    }
}

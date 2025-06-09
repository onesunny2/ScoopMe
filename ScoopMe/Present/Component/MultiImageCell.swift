//
//  MultiImageCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/21/25.
//

import SwiftUI
import SCMLogger
import SCMImageRequest

struct MultiImageCell: View {
    
    private let mainCornerRadius: CGFloat = 10
    private let subCornerRadius: CGFloat = 4
    private var subWidth: CGFloat {
        return UIScreen.main.bounds.size.width - (width + 44)
    }
    private var subHeight: CGFloat {
        return (height - 4) / 2
    }
    
    let imageHelper: ImageHelper
    var onlyImage: Bool = false
    let likeStatus: Bool
    let picchelinStatus: Bool
    let images: [String]
    let width: CGFloat
    let height: CGFloat
    var moreImage: Bool = false
    
    var likeButtonAction: (() -> Void)?
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            mainImage
            subImages
        }
        .frame(height: height)
    }
    
    @ViewBuilder
    private var mainImage: some View {
        if onlyImage {
            NukeRequestImageCell(
                imageHelper: imageHelper,
                url: images[at: 0],
                topLeading: mainCornerRadius,
                bottomLeading: mainCornerRadius,
                bottomTrailing: subCornerRadius,
                topTrailing: subCornerRadius
            )
            .frame(width: width, height: height)
            .clippedUnevenRectangle(
                mainCornerRadius,
                mainCornerRadius,
                subCornerRadius,
                subCornerRadius
            )
        } else {
            NukeRequestImageCell(
                imageHelper: imageHelper,
                url: images[at: 0],
                topLeading: mainCornerRadius,
                bottomLeading: mainCornerRadius,
                bottomTrailing: subCornerRadius,
                topTrailing: subCornerRadius
            )
            .frame(width: width, height: height)
            .clippedUnevenRectangle(
                mainCornerRadius,
                mainCornerRadius,
                subCornerRadius,
                subCornerRadius
            )
            .badgeOverlay(
                likeStatus: likeStatus,
                picchelinStatus: picchelinStatus,
                likeOpacity: 1,
                padding: 8
            ) {
                likeButtonAction?()
            }
        }
    }
    
    private var subImages: some View {
        VStack(alignment: .leading, spacing: 4) {
            NukeRequestImageCell(
                imageHelper: imageHelper,
                url: images[at: 1],
                topLeading: subCornerRadius,
                bottomLeading: subCornerRadius,
                bottomTrailing: mainCornerRadius,
                topTrailing: mainCornerRadius
            )
            .frame(width: subWidth, height: subHeight)
            .clippedUnevenRectangle(
                subCornerRadius,
                subCornerRadius,
                mainCornerRadius,
                mainCornerRadius
            )
            
            NukeRequestImageCell(
                imageHelper: imageHelper,
                url: images[at: 2],
                topLeading: subCornerRadius,
                bottomLeading: subCornerRadius,
                bottomTrailing: mainCornerRadius,
                topTrailing: mainCornerRadius
            )
            .frame(width: subWidth, height: subHeight)
            .clippedUnevenRectangle(
                subCornerRadius,
                subCornerRadius,
                mainCornerRadius,
                mainCornerRadius
            )
            .overlay(alignment: .center) {
                if moreImage {
                    Color.scmGray90.opacity(0.4)
                    Text("Test")
                }
            }
        }
    }
}

#Preview {
    MultiImageCell(
        imageHelper: DIContainer.shared.imageHelper,
        likeStatus: true,
        picchelinStatus: true,
        images: [],
        width: 268,
        height: 128
    ) {
        Log.debug("하트 클릭")
    }
}

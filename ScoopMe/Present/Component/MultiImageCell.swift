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
    
    private let cornerRadius: CGFloat = 10
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
                topLeading: cornerRadius,
                bottomLeading: cornerRadius,
                bottomTrailing: cornerRadius,
                topTrailing: cornerRadius
            )
            .frame(width: width, height: height)
            .clippedUnevenRectangle(
                cornerRadius,
                cornerRadius,
                cornerRadius,
                cornerRadius
            )
        } else {
            NukeRequestImageCell(
                imageHelper: imageHelper,
                url: images[at: 0],
                topLeading: cornerRadius,
                bottomLeading: cornerRadius,
                bottomTrailing: cornerRadius,
                topTrailing: cornerRadius
            )
            .frame(width: width, height: height)
            .clippedUnevenRectangle(
                cornerRadius,
                cornerRadius,
                cornerRadius,
                cornerRadius
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
                topLeading: cornerRadius,
                bottomLeading: cornerRadius,
                bottomTrailing: cornerRadius,
                topTrailing: cornerRadius
            )
            .frame(width: subWidth, height: subHeight)
            .clippedUnevenRectangle(
                cornerRadius,
                cornerRadius,
                cornerRadius,
                cornerRadius
            )
            
            NukeRequestImageCell(
                imageHelper: imageHelper,
                url: images[at: 2],
                topLeading: cornerRadius,
                bottomLeading: cornerRadius,
                bottomTrailing: cornerRadius,
                topTrailing: cornerRadius
            )
            .frame(width: subWidth, height: subHeight)
            .clippedUnevenRectangle(
                cornerRadius,
                cornerRadius,
                cornerRadius,
                cornerRadius
            )
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

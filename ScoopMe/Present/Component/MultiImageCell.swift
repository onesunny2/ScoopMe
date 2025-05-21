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
    private var subHeight: CGFloat {
        return (height - 4) / 2
    }
    
    let imageHelper: ImageHelper
    let likeStatus: Bool
    let picchelinStatus: Bool
    let images: [String]
    let width: CGFloat
    let height: CGFloat
    
    var likeButtonAction: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            mainImage
            subImages
        }
        .defaultHorizontalPadding()
    }
    
    private var mainImage: some View {
        NukeRequestImageCell(
            imageHelper: imageHelper,
            likeStatus: likeStatus,
            picchelinStatus: picchelinStatus,
            likeOpacity: 1,
            url: images[at: 0],
            topLeading: cornerRadius,
            bottomLeading: cornerRadius,
            bottomTrailing: cornerRadius,
            topTrailing: cornerRadius,
            width: width,
            height: height
        ) {
            likeButtonAction()
        }
    }
    
    private var subImages: some View {
        VStack(alignment: .leading, spacing: 4) {
            NukeRequestImageCell(
                imageHelper: imageHelper,
                likeStatus: false,
                picchelinStatus: false,
                likeOpacity: 0,
                url: images[at: 1],
                topLeading: cornerRadius,
                bottomLeading: cornerRadius,
                bottomTrailing: cornerRadius,
                topTrailing: cornerRadius,
                width: .infinity,
                height: subHeight,
                likeButtonAction: nil
            )
            
            NukeRequestImageCell(
                imageHelper: imageHelper,
                likeStatus: false,
                picchelinStatus: false,
                likeOpacity: 0,
                url: images[at: 2],
                topLeading: cornerRadius,
                bottomLeading: cornerRadius,
                bottomTrailing: cornerRadius,
                topTrailing: cornerRadius,
                width: .infinity,
                height: subHeight,
                likeButtonAction: nil
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

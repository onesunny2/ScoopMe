//
//  RealtimePopularScoopCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/20/25.
//

import SwiftUI
import NukeUI
import SCMImageRequest
import SCMLogger
import SCMScoopInfo

struct RealtimePopularScoopCell: View {
    
    private let imageHelper: ImageHelper
    let store: RealtimePopularScoopEntity
    let likeButtonOpacity: Double
    var likeButtonAction: () -> Void
    
    init(
        imageHelper: ImageHelper,
        store: RealtimePopularScoopEntity,
        likeButtonOpacity: Double,
        likeButtonAction: @escaping () -> Void
    ) {
        self.imageHelper = imageHelper
        self.store = store
        self.likeButtonOpacity = likeButtonOpacity
        self.likeButtonAction = likeButtonAction
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            topSection
            bottomSection
        }
    }
    
    @ViewBuilder
    private var topSection: some View {
        NukeRequestImageCell(
            imageHelper: imageHelper,
            likeStatus: store.likeStatus,
            picchelinStatus: store.picchelinStatus,
            likeOpacity: likeButtonOpacity,
            url: store.storeImage,
            topLeading: 10,
            bottomLeading: 0,
            bottomTrailing: 0,
            topTrailing: 10,
            width: 135,
            height: 122
        ) {
            likeButtonAction()
        }
    }
    
    private var bottomSection: some View {
        UnevenRoundedRectangle(bottomLeadingRadius: 10, bottomTrailingRadius: 10)
            .fill(.scmGray0)
            .frame(width: 135, height: 73)
            .overlay(alignment: .leading) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(store.storeName)
                        .basicText(.PTBody3, .scmGray90)

                    likeCount
                    .padding(.bottom, 6)

                    distanceAndPickup
                }
                .padding(.leading, 8)
            }
    }

    private var likeCount: some View {
        HStack(alignment: .center, spacing: 2) {
            Image(.likeFill)
                .basicImage(width: 16, color: .scmBrightForsythia)
            Text(store.likeCount)
                .basicText(.PTBody3, .scmGray90)
        }
    }

    private var distanceAndPickup: some View {
        HStack(alignment: .center, spacing: 2) {
            Image(.distance)
                .basicImage(width: 16, color: .scmBlackSprout)
            Text(store.distance)
                .basicText(.PTBody4, .scmGray75)
                .padding(.trailing, 4)

            Image(.run)
                .basicImage(width: 16, color: .scmBlackSprout)
            Text(store.orderCount)
                .basicText(.PTBody4, .scmGray75)
        }
    }
}

//
//  RealtimePopularScoopCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/20/25.
//

import SwiftUI
import NukeUI
import SCMLogger
import SCMScoopInfo

struct RealtimePopularScoopCell: View {
    
    let store: RealtimePopularScoopEntity
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            topSection
            bottomSection
        }
    }
    
    private var topSection: some View {
        LazyImage(url: URL(string: store.storeImage))
            .basicImage(.fill, width: 135, height: 122)
            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 10, topTrailingRadius: 10))
            .overlay(alignment: .topLeading) {
                badges
            }
    }
    
    private var badges: some View {
        HStack(alignment: .center) {
            Image(store.likeStatus ? .likeFill : .likeEmpty)
                .basicImage(width: 24, color: store.likeStatus ? .scmBlackSprout : .scmGray45)
                .padding([.top, .leading], 5)
                .asButton {
                    Log.debug("좋아요 버튼 클릭 - 나중에 서버연결 해야함")
                }
            
            Spacer()
            
            PickBadgeCell()
                .opacity(store.picchelinStatus ? 1 : 0)
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

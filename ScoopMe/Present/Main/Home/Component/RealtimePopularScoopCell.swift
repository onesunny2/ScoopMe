//
//  RealtimePopularScoopCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/20/25.
//

import SwiftUI
import SCMLogger

struct RealtimePopularScoopEntity {
    let scoopID: Int
    let scoopImage: Image
    let likeStatus: Bool
    let scoopName: String
    let likeCount: String
    let distance: String
    let pickupCount: String
}

struct RealtimePopularScoopCell: View {
    
    let scoop: RealtimePopularScoopEntity
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            topSection
            bottomSection
        }
    }
    
    private var topSection: some View {
        scoop.scoopImage
            .basicImage(.fill, width: 135, height: 122)
            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 10, topTrailingRadius: 10))
            .overlay(alignment: .topLeading) {
                badges
            }
    }
    
    private var badges: some View {
        HStack(alignment: .center) {
            Image(.likeFill)
                .basicImage(width: 24, color: .scmBlackSprout)
                .padding([.top, .leading], 5)
                .asButton {
                    Log.debug("좋아요 버튼 클릭 - 나중에 서버연결 해야함")
                }
            
            Spacer()
            
            PickBadgeCell()
        }
    }
    
    private var bottomSection: some View {
        UnevenRoundedRectangle(bottomLeadingRadius: 10, bottomTrailingRadius: 10)
            .fill(.scmGray0)
            .frame(width: 135, height: 73)
            .overlay(alignment: .leading) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(scoop.scoopName)
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
            Text(scoop.likeCount)
                .basicText(.PTBody3, .scmGray90)
        }
    }
    
    private var distanceAndPickup: some View {
        HStack(alignment: .center, spacing: 2) {
            Image(.distance)
                .basicImage(width: 16, color: .scmBlackSprout)
            Text(scoop.distance)
                .basicText(.PTBody4, .scmGray75)
                .padding(.trailing, 4)
            
            Image(.run)
                .basicImage(width: 16, color: .scmBlackSprout)
            Text(scoop.pickupCount)
                .basicText(.PTBody4, .scmGray75)
        }
    }
}

#Preview {
    ZStack {
        Color.scmGray75
            .ignoresSafeArea()
        
        RealtimePopularScoopCell(
            scoop: RealtimePopularScoopEntity(
                scoopID: 0,
                scoopImage: Image(.mangoTest),
                likeStatus: true,
                scoopName: "새싹 망빙 전문점",
                likeCount: "100개",
                distance: "0.5km",
                pickupCount: "111회"
            )
        )
    }
}

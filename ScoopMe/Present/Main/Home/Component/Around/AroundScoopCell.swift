//
//  AroundScoopCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/20/25.
//

import SwiftUI
import SCMImageRequest
import SCMLogger
import SCMScoopInfo

struct AroundScoopCell: View {
    
    let imageHelper: ImageHelper
    let store: AroundStoreInfoEntity
    
    var likeButtonAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            imageCell
            storeInfoCell
        }
    }
    
    private var imageCell: some View {
        MultiImageCell(
            imageHelper: imageHelper,
            likeStatus: store.likeStatus,
            picchelinStatus: store.picchelinStatus,
            images: store.storeImage,
            width: 268,
            height: 180) {
                likeButtonAction()
            }
    }
    
    private var storeInfoCell: some View {
        VStack(alignment: .leading, spacing: 8) {
            storeTitleAndRate
            storeManageInfo
            hashTagBadge
        }
    }
    
    private var storeTitleAndRate: some View {
        HStack(alignment: .center) {
            Text(store.storeName)
                .basicText(.PTTitle3, .scmGray90)
                .lineLimit(1)
                .truncationMode(.tail)
            
            HStack(alignment: .center, spacing: 2) {
                Image(.likeFill)
                    .basicImage(width: 20, color: .scmBrightForsythia)
                Text(store.likeCount)
                    .basicText(.PTTitle3, .scmGray90)
                    .padding(.trailing, 6)
                
                Image(.favoriteFill)
                    .basicImage(width: 20, color: .scmBrightForsythia)
                Text(store.totalRating)
                    .basicText(.PTTitle3, .scmGray90)
                Text(store.totalReview)
                    .basicText(.PTTitle5, .scmGray60)
            }
        }
    }
    
    private var storeManageInfo: some View {
        HStack(alignment: .center, spacing: 2) {
            Image(.distance)
                .basicImage(width: 20, color: .scmBlackSprout)
            Text(store.distance)
                .basicText(.PTBody5, .scmGray60)
                .padding(.trailing, 6)
            
            Image(.time)
                .basicImage(width: 20, color: .scmBlackSprout)
            Text(store.closeTime)
                .basicText(.PTBody5, .scmGray60)
                .padding(.trailing, 6)
            
            Image(.run)
                .basicImage(width: 20, color: .scmBlackSprout)
            Text(store.orderCount)
                .basicText(.PTBody5, .scmGray60)
                .padding(.trailing, 6)
        }
    }
    
    private var hashTagBadge: some View {
        HStack(alignment: .center, spacing: 8) {
            ForEach(store.hashTags, id: \.self) { tag in
                Text(tag)
                    .basicText(.PTCaption1, .scmGray0)
                    .tagBadge(.scmDeepSprout)
            }
        }
    }
}

#Preview {
    AroundScoopCell(
        imageHelper: DIContainer.shared.imageHelper,
        store: AroundStoreInfoEntity(
            storeID: "68232364ca81ef0db5a4628d",
            storeName: "스쿱 베이커리",
            storeImage: [
                "/v1/data/stores/alan-hardman-SU1LFoeEUkk-unsplash_1747128644203.jpg",
                "/v1/data/stores/chad-montano-MqT0asuoIcU-unsplash_1747128644346.jpg",
                "/v1/data/stores/shourav-sheikh-a66sGfOnnqQ-unsplash_1747128644500.jpg"
            ],
            likeStatus: true,
            picchelinStatus: true,
            likeCount: "5번",
            totalRating: "4.8",
            totalReview: "(12)",
            distance: "3.2km",
            closeTime: "10PM",
            orderCount: "88회",
            hashTags: ["#스쿱미", "#맛있어요"]
        )
    ) {
        Log.debug("좋아요 버튼 클릭")
    }
}

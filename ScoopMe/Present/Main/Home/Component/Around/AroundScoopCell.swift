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
            totalRating: "4.8(2)",
            distance: "3.2km",
            closeTime: "10PM",
            orderCount: "88회",
            hashTags: ["#스쿱미", "#맛있어요"]
        )
    ) {
        Log.debug("좋아요 버튼 클릭")
    }
}

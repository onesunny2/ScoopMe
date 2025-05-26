//
//  StoreDetailRepository.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/26/25.
//

import Foundation

public class MockStoreDetailRepository: StoreDetailDisplayable {
    
    public init() { }
    
    public func getStoreDetailInfo(id: String) async throws -> StoreDetailInfoEntity {
        return StoreDetailInfoEntity(
            storeID: "Test",
            storeName: "원선 스쿱 가게",
            imageUrls: [
                Secret.baseURL + "/v1/data/stores/alan-hardman-SU1LFoeEUkk-unsplash_1747128644203.jpg",
                Secret.baseURL + "/v1/data/stores/chad-montano-MqT0asuoIcU-unsplash_1747128644346.jpg",
                Secret.baseURL + "/v1/data/stores/shourav-sheikh-a66sGfOnnqQ-unsplash_1747128644500.jpg"
            ],
            picchelinStatus: true,
            likeStatus: false,
            address: "서울시 스쿱구 원선20길 96, 730동",
            parkingInfo: "매장 건물 지하주차장",
            time: "매주 월~토 10:00 ~ 19:00",
            rating: "4.9",
            review: "(333)",
            distance: "2.2km"
        )
    }
}

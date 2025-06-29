////
////  MockFoodCategoryRepository.swift
////  SCMScoopInfo
////
////  Created by Lee Wonsun on 5/20/25.
////
//
//import SwiftUI
//import Combine
//
//public final class MockFoodCategoryRepository: FoodCategoryDisplayable {
//    
//    @Published public var categoryNames: [String] = [
//        "커피", "패스트푸드", "디저트", "베이커리", "더보기", "한식", "일식", "분식", "샐러드", "샌드위치"
//    ]
//    @Published public var categoryImages: [Image] = [
//        Image(.coffee), Image(.fastFood), Image(.dessert), Image(.bakery), Image(.more),
//        Image(.hansik), Image(.ilsik), Image(.bunsik), Image(.salad), Image(.sandwich)
//    ]
//    
//    @Published public var selectedCategory: Category = .커피
//    
//    public init() { }
//    
//    public func getPopularKeywords() async throws -> [String] {
//        let keywords = [
//            "스쿱 베이커리",
//            "달콤 스쿱",
//            "스쿱 치킨 점바점"
//        ]
//        return keywords
//    }
//    
//    public func getPopularStoresInfo() async -> [RealtimePopularScoopEntity] {
//        return Array(
//            repeating: RealtimePopularScoopEntity(
//                storeID: "id_\(Int.random(in: 0...222))",
//                storeName: "스쿱스쿱",
//                storeImage: Secret.baseURL + "/v1/data/stores/jeremy-yap-jn-HaGWe4yw-unsplash_1747128572373.jpg",
//                likeStatus: false,
//                picchelinStatus: true,
//                likeCount: "100개",
//                distance: "22.2km",
//                orderCount: "22회"
//            ),
//            count: 10
//        )
//    }
//    
//    public func getAroundStoreInfo(_ round: AroundType, _ filter: AroundFilterType) async -> [AroundStoreInfoEntity] {
//        // round는 픽슐랭, filter는 거리순을 기준으로 둠!
//        return [
//            AroundStoreInfoEntity(
//                storeID: "68232364ca81ef0db5a4628d",
//                storeName: "스쿱 베이커리",
//                storeImage: [
//                    Secret.baseURL + "/v1/data/stores/alan-hardman-SU1LFoeEUkk-unsplash_1747128644203.jpg",
//                    Secret.baseURL + "/v1/data/stores/chad-montano-MqT0asuoIcU-unsplash_1747128644346.jpg",
//                    Secret.baseURL + "/v1/data/stores/shourav-sheikh-a66sGfOnnqQ-unsplash_1747128644500.jpg"
//                  ],
//                likeStatus: true,
//                picchelinStatus: true,
//                likeCount: "5개",
//                totalRating: "4.8",
//                totalReview: "(12)",
//                distance: "3.2km",
//                closeTime: "10PM",
//                orderCount: "88회",
//                hashTags: ["#스쿱미", "#맛있어요"]
//            ),
//            AroundStoreInfoEntity(
//                storeID: "68231cb9ca81ef0db5a46063",
//                storeName: "스쿱 치킨 점바점",
//                storeImage: [
//                    Secret.baseURL + "/v1/data/stores/ante-samarzija-lsmu0rUhUOk-unsplash_1747128571997.jpg",
//                    Secret.baseURL + "/v1/data/stores/demi-deherrera-L-sm1B4L1Ns-unsplash_1747128572138.jpg",
//                    Secret.baseURL + "/v1/data/stores/jeremy-yap-jn-HaGWe4yw-unsplash_1747128572373.jpg"
//                  ],
//                likeStatus: false,
//                picchelinStatus: true,
//                likeCount: "55개",
//                totalRating: "5.0",
//                totalReview: "(30)",
//                distance: "0.6km",
//                closeTime: "11PM",
//                orderCount: "143회",
//                hashTags: ["#점바점", "#우리지점이짱"]
//            ),
//            AroundStoreInfoEntity(
//                storeID: "68231d1dca81ef0db5a4609b",
//                storeName: "달콤 스쿱 달콤 스쿱 달콤 스쿱 달콤 스쿱 달콤 스쿱 달콤 스쿱",
//                storeImage: [
//                    Secret.baseURL + "/v1/data/stores/heather-ford-POM4KxWZcG8-unsplash_1747137090839.jpg",
//                    Secret.baseURL + "/v1/data/stores/heather-barnes-WbZesfqwR-A-unsplash_1747137090961.jpg",
//                    Secret.baseURL + "/v1/data/stores/kobby-mendez-q54Oxq44MZs-unsplash_1747137091086.jpg"
//                  ],
//                likeStatus: true,
//                picchelinStatus: true,
//                likeCount: "182개",
//                totalRating: "4.9",
//                totalReview: "(121)",
//                distance: "1.6km",
//                closeTime: "11PM",
//                orderCount: "325회",
//                hashTags: ["#달콤~한", "#스쿱스쿱"]
//            )
//        ]
//    }
//    
//    public func postStoreLikeStatus(store id: String, like status: Bool) async throws {
//        print(#function)
//    }
//}

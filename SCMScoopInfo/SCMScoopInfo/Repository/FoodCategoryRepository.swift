//
//  FoodCategoryRepository.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/22/25.
//

import SwiftUI
import Combine
import SCMLocation
internal import SCMLogin
import SCMLogger
internal import SCMNetwork

public final class FoodCategoryRepository: FoodCategoryDisplayable {
    
    @Published public var categoryNames: [String]
    @Published public var categoryImages: [Image]
    
    @Published public var selectedCategory: Category = .커피
    @Published public var selectedFiltering: AroundFilterType = .distance
    
    private let loginTokenManager: LoginTokenManager
    private let locationManager: LocationManager
    private let network: SCMNetworkImpl
    
    public init() {
        self.loginTokenManager = LoginTokenManager()
        self.locationManager = LocationManager()
        self.network = SCMNetworkImpl()
        
        self.categoryNames = Category.allCases.map { $0.text }
        self.categoryImages = Category.allCases.map { $0.image }
    }
    
    public func getPopularKeywords() async -> [String] {

        do {
            let accesToken = loginTokenManager.fetchToken(.accessToken)
            let value = ScoopInfoURL.popularKeyword(access: accesToken)
            let result = try await callRequest(value, type: PopularSearchKeywordDTO.self)
            
            Log.debug("✅ 인기검색어 통신 성공: \(result.response.data)")
            
            return PopularSearchKeywordEntity(keywords: result.response.data).keywords
        } catch {
            Log.error("인기검색어 통신 오류")
            return []
        }
    }
    
    public func getPopularStoresInfo() async -> [RealtimePopularScoopEntity] {
        
        do {
            let accesToken = loginTokenManager.fetchToken(.accessToken)
            let value = ScoopInfoURL.realtimePopularStores(access: accesToken, category: selectedCategory)
            let result = try await callRequest(value, type: RealtimePopularStoreDTO.self)
            
            Log.debug("✅ 근처 인기스쿱 통신 성공: \(result.response)")
            
            var entity: [RealtimePopularScoopEntity] = []
            
            result.response.data.forEach { data in
                
                guard let image = data.storeImageUrls.first.map({ Secret.baseURL + "/v1" + $0 }) else { return }
                
                Log.debug("이미지 링크: \(image)")
                
                let data = RealtimePopularScoopEntity(
                    storeID: data.storeID,
                    storeName: data.name,
                    storeImage: image,
                    likeStatus: data.isPick,
                    picchelinStatus: data.isPicchelin,
                    likeCount: "\(data.pickCount)개",
                    distance: "2.2km",
                    orderCount: "\(data.totalOrderCount)회"
                )
                
                entity.append(data)
            }
            
            return entity
            
        } catch {
            Log.error("근처 인기스쿱 통신 오류: \(error)")
            return []
        }
    }
    
    public func getAroundStoreInfo(_ round: AroundType, _ filter: AroundFilterType) async -> [AroundStoreInfoEntity] {
        // round는 픽슐랭, filter는 거리순을 기준으로 둠!
        return [
            AroundStoreInfoEntity(
                storeID: "68232364ca81ef0db5a4628d",
                storeName: "스쿱 베이커리",
                storeImage: [
                    Secret.baseURL + "/v1/data/stores/alan-hardman-SU1LFoeEUkk-unsplash_1747128644203.jpg",
                    Secret.baseURL + "/v1/data/stores/chad-montano-MqT0asuoIcU-unsplash_1747128644346.jpg",
                    Secret.baseURL + "/v1/data/stores/shourav-sheikh-a66sGfOnnqQ-unsplash_1747128644500.jpg"
                  ],
                likeStatus: true,
                picchelinStatus: true,
                likeCount: "5개",
                totalRating: "4.8",
                totalReview: "(12)",
                distance: "3.2km",
                closeTime: "10PM",
                orderCount: "88회",
                hashTags: ["#스쿱미", "#맛있어요"]
            ),
            AroundStoreInfoEntity(
                storeID: "68231cb9ca81ef0db5a46063",
                storeName: "스쿱 치킨 점바점",
                storeImage: [
                    Secret.baseURL + "/v1/data/stores/ante-samarzija-lsmu0rUhUOk-unsplash_1747128571997.jpg",
                    Secret.baseURL + "/v1/data/stores/demi-deherrera-L-sm1B4L1Ns-unsplash_1747128572138.jpg",
                    Secret.baseURL + "/v1/data/stores/jeremy-yap-jn-HaGWe4yw-unsplash_1747128572373.jpg"
                  ],
                likeStatus: false,
                picchelinStatus: true,
                likeCount: "55개",
                totalRating: "5.0",
                totalReview: "(30)",
                distance: "0.6km",
                closeTime: "11PM",
                orderCount: "143회",
                hashTags: ["#점바점", "#우리지점이짱"]
            ),
            AroundStoreInfoEntity(
                storeID: "68231d1dca81ef0db5a4609b",
                storeName: "달콤 스쿱 달콤 스쿱 달콤 스쿱 달콤 스쿱 달콤 스쿱 달콤 스쿱",
                storeImage: [
                    Secret.baseURL + "/v1/data/stores/heather-ford-POM4KxWZcG8-unsplash_1747137090839.jpg",
                    Secret.baseURL + "/v1/data/stores/heather-barnes-WbZesfqwR-A-unsplash_1747137090961.jpg",
                    Secret.baseURL + "/v1/data/stores/kobby-mendez-q54Oxq44MZs-unsplash_1747137091086.jpg"
                  ],
                likeStatus: true,
                picchelinStatus: true,
                likeCount: "182개",
                totalRating: "4.9",
                totalReview: "(121)",
                distance: "1.6km",
                closeTime: "11PM",
                orderCount: "325회",
                hashTags: ["#달콤~한", "#스쿱스쿱"]
            )
        ]
    }
}

// MARK: private func
extension FoodCategoryRepository {
    private func callRequest<T: Decodable>(_ value: ScoopInfoURL, type: T.Type) async throws -> HTTPResponse<T> {
        let request = HTTPRequest(
            scheme: .http,
            method: value.method,
            successCodes: [200]
        )
            .addBaseURL(value.baseURL)
            .addPath(value.path)
            .addParameters(value.parameters)
            .addHeaders(value.headers)
        
        return try await network.fetchData(request, T.self)
    }
    
    private func getAllStoresFirst() async {
        do {
            let accessToken = loginTokenManager.fetchToken(.accessToken)
            let location = locationManager.currentLocation
            let value = ScoopInfoURL.nearbyStoreFirst(
                access: accessToken,
                category: selectedCategory.text,
                longitude: Float(location.coordinate.longitude),
                latitude: Float(location.coordinate.latitude),
                limit: 5,
                orderBy: selectedFiltering
            )
            let result = try await callRequest(value, type: AllStoreListResponseDTO.self)
            
            Log.debug("근처 전체 검색결과: \(result.response.data)")
            
        } catch {
            Log.error("근처 가게 전체검색 실패: \(error)")
        }
    }
}

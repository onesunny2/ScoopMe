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
    
    @Published public var isLoading: Bool = false
    @Published public var lastStoreID: String = ""
    
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
    
    public func getPopularKeywords() async throws -> [String] {
        
        let accesToken = loginTokenManager.fetchToken(.accessToken)
        let value = ScoopInfoURL.popularKeyword(access: accesToken)
        let result = try await callRequest(value, type: PopularSearchKeywordDTO.self)
        
        Log.debug("✅ 인기검색어 통신 성공")
        
        return PopularSearchKeywordEntity(keywords: result.response.data).keywords
    }
    
    public func getPopularStoresInfo() async throws -> [RealtimePopularScoopEntity] {
        
        let accesToken = loginTokenManager.fetchToken(.accessToken)
        let value = ScoopInfoURL.realtimePopularStores(access: accesToken, category: selectedCategory)
        let result = try await callRequest(value, type: RealtimePopularStoreDTO.self)
        
        Log.debug("✅ 근처 인기스쿱 통신 성공")
        
        var entity: [RealtimePopularScoopEntity] = []
        
        result.response.data.forEach { data in
            
            guard let image = data.storeImageUrls.first.map({ Secret.baseURL + "/v1" + $0 }) else { return }
            
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
    }
    
    public func getAroundStoreInfo(_ round: AroundType) async throws -> [AroundStoreInfoEntity] {
        
        let result = try await getAllStores(store: lastStoreID)
        var entity: [AroundStoreInfoEntity] = []
        
        Log.debug("통신 결과")
        
        switch round {
        case .픽슐랭:
            let data = result.filter { $0.isPicchelin }
            
            data.forEach {
                
                let result = AroundStoreInfoEntity(
                    storeID: $0.storeID,
                    storeName: $0.name,
                    storeImage: $0.storeImageUrls.map { Secret.baseURL + "/v1" + $0 },
                    likeStatus: $0.isPick,
                    picchelinStatus: $0.isPicchelin,
                    likeCount: "\($0.pickCount)개",
                    totalRating: "\($0.totalRating)",
                    totalReview: "(\($0.totalReviewCount))",
                    distance: "\($0.distance)km",
                    closeTime: "\($0.close.prefix(2))시",
                    orderCount: "\($0.totalOrderCount)회",
                    hashTags: $0.hashTags
                )
                
                entity.append(result)
            }
            
            lastStoreID = entity.last?.storeID ?? ""
            
            Log.debug("✅ 전체 스쿱 통신 성공")
            
            return entity
            
        case .마이스쿱:
            let data = result.filter { $0.isPick }
            
            data.forEach {
                
                let result = AroundStoreInfoEntity(
                    storeID: $0.storeID,
                    storeName: $0.name,
                    storeImage: $0.storeImageUrls.map { Secret.baseURL + "/v1" + $0 },
                    likeStatus: $0.isPick,
                    picchelinStatus: $0.isPicchelin,
                    likeCount: "\($0.pickCount)개",
                    totalRating: "\($0.totalRating)",
                    totalReview: "(\($0.totalReviewCount))",
                    distance: "\($0.distance)km",
                    closeTime: "\($0.close.prefix(2))시",
                    orderCount: "\($0.totalOrderCount)회",
                    hashTags: $0.hashTags
                )
                
                entity.append(result)
            }
            
            Log.debug("✅ 전체 스쿱 통신 성공")
            
            lastStoreID = entity.last?.storeID ?? ""
            
            return entity
        }
    }
    
    public func postStoreLikeStatus(store id: String, like status: Bool) async throws {
        
        let accessToken = loginTokenManager.fetchToken(.accessToken)
        let value = ScoopInfoURL.postStoreLike(access: accessToken, storeID: id, status: status)
        let result = try await callRequest(value, type: LikeStoreResponseDTO.self)
        
        Log.debug("✅ 가게 좋아요 post 완료")
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
            .addJSONBody(value.jsonBody)
            .addHeaders(value.headers)
        
        return try await network.fetchData(request, T.self)
    }
    
    private func getAllStores(store id: String) async throws -> [AllStoreInfo] {
        
        let accessToken = loginTokenManager.fetchToken(.accessToken)
        let location = locationManager.currentLocation
        let value = ScoopInfoURL.nearbyStore(
            access: accessToken,
            category: selectedCategory.text,
            longitude: Float(location.coordinate.longitude),
            latitude: Float(location.coordinate.latitude),
            next: id,
            limit: 20,
            orderBy: selectedFiltering
        )
        let result = try await callRequest(value, type: AllStoreListResponseDTO.self)
        
        Log.debug("근처 전체 통신 성공")
        
        return result.response.data
    }
}

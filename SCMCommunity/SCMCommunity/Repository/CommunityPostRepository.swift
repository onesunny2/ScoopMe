//
//  CommunityPostRepository.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 6/5/25.
//

import Foundation
import Combine
import CoreLocation
import SCMLocation
import SCMLogger
import SCMLogin
import SCMNetwork

public final class CommunityPostRepository: CommunityPostDisplayable {
    
    @Published public var selectedFiltering: TimelineFilter = .최신순
    @Published public var isLoading: Bool = false
    @Published public var lastStoreID: String = ""
    
    private let locationManager: LocationManager
    private let loginTokenManager: LoginTokenManager
    private let network: SCMNetworkImpl
    
    public init() {
        self.locationManager = LocationManager()
        self.loginTokenManager = LoginTokenManager()
        self.network = SCMNetworkImpl()
    }
    
    public func getCommunityPost() async throws -> [CommunityPostEntity] {
        
        let accessToken = loginTokenManager.fetchToken(.accessToken)
        let geolocationPost = GeolocationPost(
            latitude: "\(locationManager.currentLocation.coordinate.latitude)",
            longitude: "\(locationManager.currentLocation.coordinate.longitude)", maxDistance: "300",
            limit: 5
        )
        Log.debug("🔗 geolocationPost 정보: \(geolocationPost)")
        let value = CommunityURL.getCommunityPost(access: accessToken, value: geolocationPost)
        let result = try await callRequest(value, type: PostSummaryPaginationResponseDTO.self)
        
        var entities: [CommunityPostEntity] = []
        
        for response in result.response.data {
            let creator = Creator(
                id: response.creator.userId,
                nickname: response.creator.nick,
                profileImage: response.creator.profileImage ?? ""
            )
            
            let storeLocation = CLLocation(latitude: response.store?.geolocation.latitude ?? 0.0, longitude: response.store?.geolocation.longitude ?? 0.0)
            let storeAddress = try await locationManager.getGeocodeLacation(storeLocation)
            let storeImage = response.store?.storeImageUrls.first ?? ""
            let storeInfo = StoreInfo(
                id: response.store?.id ?? "",
                category: response.category,
                name: response.store?.name ?? "",
                image: Secret.baseURL + "/v1" + storeImage,
                address: storeAddress
            )
            
            let distance = locationManager.currentLocation.intDistanceInM(from: storeLocation)
            let files = response.files.map { Secret.baseURL + "/v1" + $0 }
            let createdDate = Date.from(iso8601String: response.createdAt)
            
            let entity: CommunityPostEntity = CommunityPostEntity(
                creator: creator,
                postID: response.postId,
                postTitle: response.title,
                postContent: response.content,
                distance: distance,
                likeCount: Int(response.store?.pickCount ?? 0),
                likeStatus: response.isLike,
                mediaFiles: files,
                uploadTime: createdDate?.timeAgoFromNow() ?? "",
                storeInfo: storeInfo
            )
            
            entities.append(entity)
        }
        
        return entities
    }
    
    public func postStoreLikeStatus(store id: String, like status: Bool) async throws {
        
    }
}

extension CommunityPostRepository {
    
    private func callRequest<T: Decodable>(_ value: CommunityURL, type: T.Type) async throws -> HTTPResponse<T> {
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
    
    private func checkRefreshToken(complete: @escaping () async throws -> ()) async {
        do {
            try await loginTokenManager.requestRefreshToken()
            try await complete()
        } catch {
            // TODO: 만료되면 로그인 화면으로 돌아가도록 처리 필요
        }
    }
}

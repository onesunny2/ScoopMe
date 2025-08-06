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
    
    public let locationManager: LocationManager
    public let loginTokenManager: LoginTokenManager
    public let network: SCMNetworkImpl
    
    private var accessToken: String {
        return loginTokenManager.fetchToken(.accessToken)
    }
    
    public init() {
        self.locationManager = LocationManager()
        self.loginTokenManager = LoginTokenManager()
        self.network = SCMNetworkImpl()
    }
    
    public func getCommunityPost(
        max distance: Int = 300,
        orderBy: TimelineFilter = .최신순,
        next: String? = nil
    ) async throws -> postForPagination {
        
        let geolocationPost = GeolocationPost(
            latitude: "\(locationManager.currentLocation.coordinate.latitude)",
            longitude: "\(locationManager.currentLocation.coordinate.longitude)",
            maxDistance: "\(distance)",
            limit: 5,
            next: next,
            orderBy: orderBy
        )
        let value = CommunityURL.getCommunityPost(access: accessToken, value: geolocationPost)
        let result = try await callRequest(value, type: PostSummaryPaginationResponseDTO.self)
        
        var entities: [CommunityPostEntity] = []
        let responses = result.response.data
        
        for response in responses {
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
            let comments = try await getPostComment(postID: response.postId)
            
            let entity: CommunityPostEntity = CommunityPostEntity(
                creator: creator,
                postID: response.postId,
                postTitle: response.title,
                postContent: response.content,
                distance: distance,
                likeCount: Int(response.likeCount),
                likeStatus: response.isLike,
                mediaFiles: files,
                uploadTime: createdDate?.timeAgoFromNow() ?? "",
                storeInfo: storeInfo,
                comments: comments
            )
            
            entities.append(entity)
        }
        
        let nextCursor = result.response.nextCursor
        
        Log.debug("🔗 현재 포스트리스트: \(entities)", "🔗 다음커서: \(nextCursor)")
        
        return (entities, nextCursor)
    }
    
    public func deleteCommunityPost(postID: String) async throws {
        let value = CommunityURL.deleteCommunityPost(access: accessToken, postID: postID)
        let result = try await callEmptyRequest(value)
        
        Log.debug("✅ 삭제 완료: \(result.statusCode.description)")
    }
    
    public func editContents(
        postID: String,
        content: EditContent
    ) async throws {
        
        let value = CommunityURL.editCommunityPost(access: accessToken, postID: postID, content: content)
        _ = try await callRequest(value, type: PostResponseDTO.self)
        
        Log.debug("✅ 포스트 수정 성공")
    }
    
    public func postStoreLikeStatus(store id: String, like status: Bool) async throws {
        
    }
}

extension CommunityPostRepository {
    private func getPostComment(postID: String) async throws -> [CommentResponseDTO] {
        let value = CommunityURL.getPostDetail(access: accessToken, postID: postID)
        let result = try await callRequest(value, type: PostResponseDTO.self)
        
        return result.response.comments
    }
}

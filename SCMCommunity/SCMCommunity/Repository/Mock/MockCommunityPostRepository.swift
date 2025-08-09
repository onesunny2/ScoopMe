//
//  MockCommunityPostRepository.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 5/30/25.
//

import Foundation
import SCMLocation
import SCMLogin
import SCMNetwork

public final class MockCommunityPostRepository: CommunityPostDisplayable {
    
    public var locationManager: LocationManager
    public var loginTokenManager: LoginTokenManager
    public var network: SCMNetworkImpl
    
    public init() {
        self.locationManager = LocationManager()
        self.loginTokenManager = LoginTokenManager()
        self.network = SCMNetworkImpl()
    }
    
    public func getCommunityPost(max distance: Int, orderBy: TimelineFilter, next: String?) async throws -> postForPagination {

//        let creator = Creator(
//            id: "65c9aa6932b0964405117d97",
//            nickname: "이원선",
//            profileImage: Secret.baseURL + "/v1/data/stores/alan-hardman-SU1LFoeEUkk-unsplash_1747128644203.jpg"
//        )
//        
//        let store = StoreInfo(
//            id: "670bcd66539a670e42b2a3d8",
//            category: "커피",
//            name: "츄르르르",
//            image: Secret.baseURL + "/v1/data/stores/alan-hardman-SU1LFoeEUkk-unsplash_1747128644203.jpg",
//            address: "짜몽시 고양동 숨숨리0130, 730호"
//        )
        
        return ([], "")
    }
    
    public func deleteCommunityPost(postID: String) async throws {
        
    }
    
    public func editContents(postID: String, content: EditContent) async throws {
        
    }
    
    public func postStoreLikeStatus(store id: String, like status: Bool) async throws {
        
    }
}

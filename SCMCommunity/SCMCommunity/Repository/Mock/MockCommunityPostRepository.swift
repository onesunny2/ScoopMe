//
//  MockCommunityPostRepository.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 5/30/25.
//

import Foundation
import Combine

public final class MockCommunityPostRepository: CommunityPostDisplayable {
    
    public init () { }
    
    public func getCommunityPost(max distance: Int, orderBy: TimelineFilter, next: String?) async throws -> postForPagination {
        
        let creator = Creator(
            id: "65c9aa6932b0964405117d97",
            nickname: "이원선",
            profileImage: Secret.baseURL + "/v1/data/stores/alan-hardman-SU1LFoeEUkk-unsplash_1747128644203.jpg"
        )
        
        let store = StoreInfo(
            id: "670bcd66539a670e42b2a3d8",
            category: "커피",
            name: "츄르르르",
            image: Secret.baseURL + "/v1/data/stores/alan-hardman-SU1LFoeEUkk-unsplash_1747128644203.jpg",
            address: "짜몽시 고양동 숨숨리0130, 730호"
        )
        
        return ([
            CommunityPostEntity(
                creator: creator,
                postID: "670bcd66539a670e42b2a3d8" + "\(Int.random(in: 0...100))",
                postTitle: "츄르 가득한 오후, 숨숨리에서",
                postContent: "좁은 골목 끝에 숨어있던 작은 츄하우스. 새싹처럼 피어나는 비릿한 츄르 스틱. 아아 목욕은 하기 싫지만, 목욕하고 주는 츄르가 너무 맛있어. 추억의 그 츄르가 떠오르게 하는 츄르르르로 어서오세요 :3",
                distance: 222,
                likeCount: 22,
                likeStatus: false,
                mediaFiles: [Secret.baseURL + "/v1/data/stores/alan-hardman-SU1LFoeEUkk-unsplash_1747128644203.jpg"],
                uploadTime: "1시간 전",
                storeInfo: store
            ),
            CommunityPostEntity(
                creator: creator,
                postID: "670bcd66539a670e42b2a3d8" + "\(Int.random(in: 0...100))",
                postTitle: "츄르 가득한 오후, 숨숨리에서",
                postContent: "좁은 골목 끝에 숨어있던 작은 츄하우스. 새싹처럼 피어나는 비릿한 츄르 스틱. 아아 목욕은 하기 싫지만, 목욕하고 주는 츄르가 너무 맛있어. 추억의 그 츄르가 떠오르게 하는 츄르르르로 어서오세요 :3",
                distance: 222,
                likeCount: 22,
                likeStatus: false,
                mediaFiles: [Secret.baseURL + "/v1/data/stores/alan-hardman-SU1LFoeEUkk-unsplash_1747128644203.jpg"],
                uploadTime: "1시간 전",
                storeInfo: store
            ),
            CommunityPostEntity(
                creator: creator,
                postID: "670bcd66539a670e42b2a3d8" + "\(Int.random(in: 0...100))",
                postTitle: "츄르 가득한 오후, 숨숨리에서",
                postContent: "좁은 골목 끝에 숨어있던 작은 츄하우스. 새싹처럼 피어나는 비릿한 츄르 스틱. 아아 목욕은 하기 싫지만, 목욕하고 주는 츄르가 너무 맛있어. 추억의 그 츄르가 떠오르게 하는 츄르르르로 어서오세요 :3",
                distance: 222,
                likeCount: 22,
                likeStatus: false,
                mediaFiles: [Secret.baseURL + "/v1/data/stores/alan-hardman-SU1LFoeEUkk-unsplash_1747128644203.jpg"],
                uploadTime: "1시간 전",
                storeInfo: store
            ),
            CommunityPostEntity(
                creator: creator,
                postID: "670bcd66539a670e42b2a3d8" + "\(Int.random(in: 0...100))",
                postTitle: "츄르 가득한 오후, 숨숨리에서",
                postContent: "좁은 골목 끝에 숨어있던 작은 츄하우스. 새싹처럼 피어나는 비릿한 츄르 스틱. 아아 목욕은 하기 싫지만, 목욕하고 주는 츄르가 너무 맛있어. 추억의 그 츄르가 떠오르게 하는 츄르르르로 어서오세요 :3",
                distance: 222,
                likeCount: 22,
                likeStatus: false,
                mediaFiles: [Secret.baseURL + "/v1/data/stores/alan-hardman-SU1LFoeEUkk-unsplash_1747128644203.jpg"],
                uploadTime: "1시간 전",
                storeInfo: store
            ),
            CommunityPostEntity(
                creator: creator,
                postID: "670bcd66539a670e42b2a3d8" + "\(Int.random(in: 0...100))",
                postTitle: "츄르 가득한 오후, 숨숨리에서",
                postContent: "좁은 골목 끝에 숨어있던 작은 츄하우스. 새싹처럼 피어나는 비릿한 츄르 스틱. 아아 목욕은 하기 싫지만, 목욕하고 주는 츄르가 너무 맛있어. 추억의 그 츄르가 떠오르게 하는 츄르르르로 어서오세요 :3",
                distance: 222,
                likeCount: 22,
                likeStatus: false,
                mediaFiles: [Secret.baseURL + "/v1/data/stores/alan-hardman-SU1LFoeEUkk-unsplash_1747128644203.jpg"],
                uploadTime: "1시간 전",
                storeInfo: store
            ),
            CommunityPostEntity(
                creator: creator,
                postID: "670bcd66539a670e42b2a3d8" + "\(Int.random(in: 0...100))",
                postTitle: "츄르 가득한 오후, 숨숨리에서",
                postContent: "좁은 골목 끝에 숨어있던 작은 츄하우스. 새싹처럼 피어나는 비릿한 츄르 스틱. 아아 목욕은 하기 싫지만, 목욕하고 주는 츄르가 너무 맛있어. 추억의 그 츄르가 떠오르게 하는 츄르르르로 어서오세요 :3",
                distance: 222,
                likeCount: 22,
                likeStatus: false,
                mediaFiles: [Secret.baseURL + "/v1/data/stores/alan-hardman-SU1LFoeEUkk-unsplash_1747128644203.jpg"],
                uploadTime: "1시간 전",
                storeInfo: store
            ),
            CommunityPostEntity(
                creator: creator,
                postID: "670bcd66539a670e42b2a3d8" + "\(Int.random(in: 0...100))",
                postTitle: "츄르 가득한 오후, 숨숨리에서",
                postContent: "좁은 골목 끝에 숨어있던 작은 츄하우스. 새싹처럼 피어나는 비릿한 츄르 스틱. 아아 목욕은 하기 싫지만, 목욕하고 주는 츄르가 너무 맛있어. 추억의 그 츄르가 떠오르게 하는 츄르르르로 어서오세요 :3",
                distance: 222,
                likeCount: 22,
                likeStatus: false,
                mediaFiles: [Secret.baseURL + "/v1/data/stores/alan-hardman-SU1LFoeEUkk-unsplash_1747128644203.jpg"],
                uploadTime: "1시간 전",
                storeInfo: store
            ),
            CommunityPostEntity(
                creator: creator,
                postID: "670bcd66539a670e42b2a3d8" + "\(Int.random(in: 0...100))",
                postTitle: "츄르 가득한 오후, 숨숨리에서",
                postContent: "좁은 골목 끝에 숨어있던 작은 츄하우스. 새싹처럼 피어나는 비릿한 츄르 스틱. 아아 목욕은 하기 싫지만, 목욕하고 주는 츄르가 너무 맛있어. 추억의 그 츄르가 떠오르게 하는 츄르르르로 어서오세요 :3",
                distance: 222,
                likeCount: 22,
                likeStatus: false,
                mediaFiles: [Secret.baseURL + "/v1/data/stores/alan-hardman-SU1LFoeEUkk-unsplash_1747128644203.jpg"],
                uploadTime: "1시간 전",
                storeInfo: store
            ),
            CommunityPostEntity(
                creator: creator,
                postID: "670bcd66539a670e42b2a3d8" + "\(Int.random(in: 0...100))",
                postTitle: "츄르 가득한 오후, 숨숨리에서",
                postContent: "좁은 골목 끝에 숨어있던 작은 츄하우스. 새싹처럼 피어나는 비릿한 츄르 스틱. 아아 목욕은 하기 싫지만, 목욕하고 주는 츄르가 너무 맛있어. 추억의 그 츄르가 떠오르게 하는 츄르르르로 어서오세요 :3",
                distance: 222,
                likeCount: 22,
                likeStatus: false,
                mediaFiles: [Secret.baseURL + "/v1/data/stores/alan-hardman-SU1LFoeEUkk-unsplash_1747128644203.jpg"],
                uploadTime: "1시간 전",
                storeInfo: store
            ),
            CommunityPostEntity(
                creator: creator,
                postID: "670bcd66539a670e42b2a3d8" + "\(Int.random(in: 0...100))",
                postTitle: "츄르 가득한 오후, 숨숨리에서",
                postContent: "좁은 골목 끝에 숨어있던 작은 츄하우스. 새싹처럼 피어나는 비릿한 츄르 스틱. 아아 목욕은 하기 싫지만, 목욕하고 주는 츄르가 너무 맛있어. 추억의 그 츄르가 떠오르게 하는 츄르르르로 어서오세요 :3",
                distance: 222,
                likeCount: 22,
                likeStatus: false,
                mediaFiles: [Secret.baseURL + "/v1/data/stores/alan-hardman-SU1LFoeEUkk-unsplash_1747128644203.jpg"],
                uploadTime: "1시간 전",
                storeInfo: store
            ),
            CommunityPostEntity(
                creator: creator,
                postID: "670bcd66539a670e42b2a3d8" + "\(Int.random(in: 0...100))",
                postTitle: "츄르 가득한 오후, 숨숨리에서",
                postContent: "좁은 골목 끝에 숨어있던 작은 츄하우스. 새싹처럼 피어나는 비릿한 츄르 스틱. 아아 목욕은 하기 싫지만, 목욕하고 주는 츄르가 너무 맛있어. 추억의 그 츄르가 떠오르게 하는 츄르르르로 어서오세요 :3",
                distance: 222,
                likeCount: 22,
                likeStatus: false,
                mediaFiles: [Secret.baseURL + "/v1/data/stores/alan-hardman-SU1LFoeEUkk-unsplash_1747128644203.jpg"],
                uploadTime: "1시간 전",
                storeInfo: store
            ),
            CommunityPostEntity(
                creator: creator,
                postID: "670bcd66539a670e42b2a3d8" + "\(Int.random(in: 0...100))",
                postTitle: "츄르 가득한 오후, 숨숨리에서",
                postContent: "좁은 골목 끝에 숨어있던 작은 츄하우스. 새싹처럼 피어나는 비릿한 츄르 스틱. 아아 목욕은 하기 싫지만, 목욕하고 주는 츄르가 너무 맛있어. 추억의 그 츄르가 떠오르게 하는 츄르르르로 어서오세요 :3",
                distance: 222,
                likeCount: 22,
                likeStatus: false,
                mediaFiles: [Secret.baseURL + "/v1/data/stores/alan-hardman-SU1LFoeEUkk-unsplash_1747128644203.jpg"],
                uploadTime: "1시간 전",
                storeInfo: store
            )
        ], "")
    }
    
    public func postStoreLikeStatus(store id: String, like status: Bool) async throws {
        
    }
}

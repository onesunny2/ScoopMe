//
//  CommunityPostCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/29/25.
//

import SwiftUI
import SCMCommunity

struct CommunityPostCell: View {
    
    let post: CommunityPostEntity
    
    init(post: CommunityPostEntity) {
        self.post = post
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            creatorView
            postImageView
            postContentsView
        }
    }
}

// MARK: UI
extension CommunityPostCell {
    private var creatorView: some View {
        HStack(alignment: .center, spacing: 8) {
            NukeRequestImageCell(
                imageHelper: DIContainer.shared.imageHelper,
                url: post.creator.profileImage,
                topLeading: 16,
                bottomLeading: 16,
                bottomTrailing: 16,
                topTrailing: 16
            )
            .frame(width: 32, height: 32)
            .clipShape(Circle())
            
            // 작성자 이름, 시간
            VStack(alignment: .leading, spacing: 4) {
                Text(post.creator.nickname)
                    .basicText(.PTCaption1, .scmGray90)
                
                Text(post.uploadTime)
                    .basicText(.PTCaption2, .scmGray60)
            }
            
            Spacer()
        }
        .frame(height: 32)
    }
    
    private var postImageView: some View {
        NukeRequestImageCell(
            imageHelper: DIContainer.shared.imageHelper,
            url: post.mediaFiles?.first ?? "",
            topLeading: 8,
            bottomLeading: 8,
            bottomTrailing: 8,
            topTrailing: 8
        )
        .frame(height: 240)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .contentShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var postContentsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 8) {
                Text(post.postTitle)
                    .basicText(.PTTitle3, .scmGray90)
                    .lineLimit(1)
                
                HStack(alignment: .center, spacing: 2) {
                    Image(.likeFill)
                        .basicImage(width: 20, color: .scmBrightForsythia)
                    Text("\(post.likeCount)개")
                        .basicText(.PTTitle3, .scmGray90)
                }
                
                HStack(alignment: .center, spacing: 2) {
                    Image(.distance)
                        .basicImage(width: 20, color: .scmBlackSprout)
                    Text("\(post.distance)m")
                        .basicText(.PTTitle3, .scmGray90)
                }
            }
            
            Text(post.postContent)
                .basicText(.PTBody6, .scmGray60)
            
            storeInfoView
        }
    }
    
    private var storeInfoView: some View {
        StoreInfoBannerCell(
            store: StoreBanner(
                name: post.storeInfo.name,
                detail: post.storeInfo.category + " • " + post.storeInfo.address,
                imageUrl: post.storeInfo.image
            )
        )
    }
}

#Preview {
    
    let creator = Creator(
        id: "65c9aa6932b0964405117d97",
        nickname: "이원선",
        profileImage: Secret.baseURL + "/v1/data/stores/cafe_main_1730000000000.jpg"
    )
    
    let store = StoreInfo(
        id: "670bcd66539a670e42b2a3d8",
        category: "커피",
        name: "츄르르르",
        image: Secret.baseURL + "/v1/data/stores/cafe_main_1730000000000.jpg",
        address: "짜몽시 고양동 숨숨리0130, 730호"
    )
    
    let entity = CommunityPostEntity(
        creator: creator,
        postID: "670bcd66539a670e42b2a3d8",
        postTitle: "츄르 가득한 오후, 숨숨리에서",
        postContent: "좁은 골목 끝에 숨어있던 작은 츄하우스. 새싹처럼 피어나는 비릿한 츄르 스틱. 아아 목욕은 하기 싫지만, 목욕하고 주는 츄르가 너무 맛있어. 추억의 그 츄르가 떠오르게 하는 츄르르르로 어서오세요 :3",
        distance: 222,
        likeCount: 22,
        likeStatus: false,
        mediaFiles: [Secret.baseURL + "/v1/data/stores/cafe_main_1730000000000.jpg"],
        uploadTime: "1시간 전",
        storeInfo: store
    )
    
    CommunityPostCell(post: entity)
        .defaultHorizontalPadding()
}

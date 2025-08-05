//
//  CommunityPostCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/29/25.
//

import SwiftUI
import SCMCommunity
import SCMLogger
import SCMLogin
import SCMImageRequest

struct CommunityPostCell: View {
    
    private let imageHelper: ImageHelper
    private var firstWidth: CGFloat {
        return UIScreen.main.bounds.size.width - 40
    }
    private var secondWidth: CGFloat {
        return (UIScreen.main.bounds.size.width - 44) / 2
    }
    private let post: CommunityPostEntity
    
    private var tappedMessage: ((Creator) -> Void)?
    
    init(
        post: CommunityPostEntity,
        tappedMessage: ((Creator) -> Void)?
    ) {
        self.imageHelper = DIContainer.shared.imageHelper
        self.post = post
        self.tappedMessage = tappedMessage
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            creatorView
            contentImageView
            postContentsView
        }
    }
}

// MARK: UI
extension CommunityPostCell {
    private var creatorView: some View {
        HStack(alignment: .center, spacing: 8) {
            NukeRequestImageCell(
                imageHelper: imageHelper,
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
            
            if post.creator.id != UserdefaultsValues.savedUserID.stringValue {
                Image(.messageFill)
                    .basicImage(width: 16, color: .scmGray15)
                    .strokeRoundBackground(.scmBrightForsythia, .scmGray30, 1, 8)
                    .asButton {
                        tappedMessage?(post.creator)
                    }
            }
        }
        .frame(height: 32)
    }
    
    @ViewBuilder
    private var contentImageView: some View {
        if let postImage = post.mediaFiles, !postImage.isEmpty {
            switch postImage.count {
            case 1: postOneImageView(postImage[0])
            case 2: postTwoImageView(first: postImage[0], second: postImage[1])
            case 3: postThreeImageView(urls: postImage)
            case 4...5: postOverThreeImageView(urls: postImage)
            default: postOneImageView(postImage[0])
            }
        }
    }
    
    private func postOneImageView(_ url: String) -> some View {
        NukeRequestImageCell(
            imageHelper: imageHelper,
            url: url,
            topLeading: 8,
            bottomLeading: 8,
            bottomTrailing: 8,
            topTrailing: 8
        )
        .frame(width: firstWidth, height: 240)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .contentShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private func postTwoImageView(first url1: String, second url2: String) -> some View {
        HStack(alignment: .center, spacing: 4) {
            imageForTwoImagesCell(url1)
            imageForTwoImagesCell(url2)
        }
    }
    
    // 이미지 2개일 때 사용할 이미지 1개의 cell
    private func imageForTwoImagesCell(_ url: String) -> some View {
        NukeRequestImageCell(
            imageHelper: imageHelper,
            url: url,
            topLeading: 8,
            bottomLeading: 8,
            bottomTrailing: 8,
            topTrailing: 8
        )
        .frame(width: secondWidth, height: secondWidth)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .contentShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private func postThreeImageView(urls: [String]) -> some View {
        MultiImageCell(
            imageHelper: imageHelper,
            onlyImage: true,
            likeStatus: false,
            picchelinStatus: false,
            images: urls,
            width: 268,
            height: 240,
            moreImage: true
        )
    }
    
    private func postOverThreeImageView(urls: [String]) -> some View {
        MultiImageCell(
            imageHelper: imageHelper,
            onlyImage: true,
            likeStatus: false,
            picchelinStatus: false,
            images: urls,
            width: 268,
            height: 240,
            moreImage: true,
            extraImagesCount: "+ \((post.mediaFiles?.count ?? 3) - 3)",
            likeButtonAction: nil
        )
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
        
            ExpandableTextView(text: post.postContent)
            
            storeInfoView
        }
    }
    
    private var storeInfoView: some View {
        StoreInfoBannerCell(
            store: StoreBanner(
                name: "[\(post.storeInfo.category)] " + post.storeInfo.name,
                detail: post.storeInfo.address,
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
    
    CommunityPostCell(
        post: entity,
        tappedMessage: nil
    )
        .defaultHorizontalPadding()
}

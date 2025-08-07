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
    private var post: CommunityPostEntity
    
    private var tappedMessage: ((Creator) -> Void)?
    private var tappedDelete: ((String) -> Void)?
    private var tappedEdit: ((CommunityPostEntity) -> Void)?
    private var tappedComment: ((CommunityPostEntity) -> Void)?
    
    init(
        post: CommunityPostEntity,
        tappedMessage: ((Creator) -> Void)?,
        tappedDelete: ((String) -> Void)?,
        tappedEdit: ((CommunityPostEntity) -> Void)?,
        tappedComment: ((CommunityPostEntity) -> Void)?
    ) {
        self.imageHelper = DIContainer.shared.imageHelper
        self.post = post
        self.tappedMessage = tappedMessage
        self.tappedDelete = tappedDelete
        self.tappedEdit = tappedEdit
        self.tappedComment = tappedComment
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
            
            Menu {
                if post.creator.id == UserdefaultsValues.savedUserID.stringValue {
                    Button(StringLiterals.edit.string) {
                        Log.debug("🔗 수정하기 버튼 탭탭")
                        tappedEdit?(post)
                    }
                    
                    Button(StringLiterals.delete.string) {
                        tappedDelete?(post.postID)
                    }
                }
                
                if post.creator.id != UserdefaultsValues.savedUserID.stringValue {
                    Button(StringLiterals.chat.string) {
                        tappedMessage?(post.creator)
                    }
                }
            } label: {
                Image(.ellipsis)
                    .basicImage(width: 16, color: .scmGray90)
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
                        .basicImage(width: 30, color: .scmBrightForsythia)
                    Text("\(post.likeCount)개")
                        .basicText(.PTTitle3, .scmGray90)
                }
                
                HStack(alignment: .center) {
                    Image(.message)
                        .basicImage(width: 22, color: .scmGray90)
                    Text("\(post.comments.count)")
                        .basicText(.PTTitle3, .scmGray90)
                }
                .asButton {
                    Log.debug("🔗 댓글 아이콘 탭탭")
                    tappedComment?(post)
                }
                
                HStack(alignment: .center, spacing: 2) {
                    Image(.distance)
                        .basicImage(width: 28, color: .scmBlackSprout)
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

// MARK: StringLiterals
private enum StringLiterals: String {
    case delete = "삭제하기"
    case edit = "수정하기"
    case chat = "채팅하기"
    
    var string: String {
        return self.rawValue
    }
}

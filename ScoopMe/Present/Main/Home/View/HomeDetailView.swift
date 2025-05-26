//
//  HomeDetailView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/19/25.
//

import SwiftUI
import SCMLogger
import SCMScoopInfo

struct HomeDetailView: View {
    
    @StateObject private var repository: AnyStoreDetailDisplayable
    
    let storeID: String
    
    @State private var storeInfos: StoreDetailInfoEntity = empty
    @State private var isShowDetail: Bool = false
    
    init(repository: AnyStoreDetailDisplayable, storeID: String) {
        self._repository = StateObject(wrappedValue: repository)
        self.storeID = storeID
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                imageTabview
                storeManageInfo
            }
        }
        .ignoresSafeArea()
        .task {
            await getStoreDetailInfo()
        }
        .backButton(.scmGray0)
        .toolbarItem (trailing: {
            Image(storeInfos.likeStatus ? .likeFill : .likeEmpty)
                .basicImage(width: 32, color: .scmGray0)
        })
        .overlay(alignment: .center) {
            if isShowDetail {
                Color.scmGray90.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring()) {
                            isShowDetail = false
                        }
                    }
                
                StoreDetailModalCell(info: storeInfos)
                    .transition(.scale)
            }
        }
    }
}

// MARK: UI
extension HomeDetailView {
    // 상단 이미지 탭뷰
    private var imageTabview: some View {
        TabView {
            ForEach(storeInfos.imageUrls, id: \.self) { url in
                NukeRequestImageCell(
                    imageHelper: DIContainer.shared.imageHelper,
                    url: url,
                    topLeading: .zero,
                    bottomLeading: .zero,
                    bottomTrailing: .zero,
                    topTrailing: .zero
                )
            }
        }
        .tabViewStyle(.page)
        .frame(maxWidth: .infinity, minHeight: 240)
    }
    
    // 상단 가게 운영 정보
    private var storeManageInfo: some View {
        VStack(alignment: .leading, spacing: 16) {
            storeTitle
            detailInfoAndReview
            loadMapAndMessage
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 32)
        .padding(.bottom, 28)
        .defaultHorizontalPadding()
        .background(.scmGray15)
    }
    
    private var storeTitle: some View {
        HStack(alignment: .center, spacing: 12) {
            Text(storeInfos.storeName)
                .basicText(.PTTitle1, .scmGray90)
            
            PickBadgeCell()
            Spacer()
        }
    }
    
    private var detailInfoAndReview: some View {
        HStack(alignment: .center) {
            HStack(alignment: .center, spacing: 4) {
                Image(.list)
                    .basicImage(width: 16, color: .scmBrightForsythia)
                Text(StringLiterals.가게_상세정보.text)
                    .basicText(.PTBody2, .scmGray75)
            }
            .strokeRoundBackground(.scmGray0, .scmGray30, 1, 100)
            .asButton {
                Log.debug("⏭️ 가게 상세정보 클릭")
                withAnimation(.spring()) {
                    isShowDetail = true
                }
            }
            
            Spacer()
            
            HStack(alignment: .center, spacing: 2) {
                Image(.favoriteFill)
                    .basicImage(width: 20, color: .scmBrightForsythia)
                Text(storeInfos.rating)
                    .basicText(.PTTitle3, .scmGray90)
                Text(storeInfos.review)
                    .basicText(.PTTitle5, .scmGray60)
                Image(.chevronRight)
                    .basicImage(width: 16, color: .scmGray60)
            }
            .asButton {
                Log.debug("⏭️ 리뷰 클릭")
            }
        }
    }
    
    private var loadMapAndMessage: some View {
        HStack(alignment: .center, spacing: 10) {
            Text("길찾기 (약 \(storeInfos.distance))")
                .basicText(.PTTitle4, .scmGray75)
                .frame(maxWidth: .infinity, minHeight: 28)
                .strokeRoundBackground(.scmBrightForsythia, .scmGray30, 1, 8)
                .asButton {
                    Log.debug("⏭️ 길찾기 클릭")
                }
            
            Image(.messageFill)
                .basicImage(width: 24, color: .scmGray15)
                .frame(height: 28)
                .padding(.horizontal, 7)
                .strokeRoundBackground(.scmBrightForsythia, .scmGray30, 1, 8)
                .asButton {
                    Log.debug("⏭️ 메신저 클릭")
                }
        }
    }
}

// MARK: Action
extension HomeDetailView {
    private func getStoreDetailInfo() async {
        do {
            let info = try await repository.getStoreDetailInfo(id: storeID)
            self.storeInfos = info
        } catch {
            await repository.checkTokenValidation(error) {
                let info = try await repository.getStoreDetailInfo(id: storeID)
                self.storeInfos = info
            }
        }
    }
}

// MARK: statie value
extension HomeDetailView {
    static let empty = StoreDetailInfoEntity(
        storeID: "Test",
        storeName: "원선 스쿱 베이커리",
        imageUrls: [
            Secret.baseURL + "/v1/data/stores/alan-hardman-SU1LFoeEUkk-unsplash_1747128644203.jpg",
            Secret.baseURL + "/v1/data/stores/chad-montano-MqT0asuoIcU-unsplash_1747128644346.jpg",
            Secret.baseURL + "/v1/data/stores/shourav-sheikh-a66sGfOnnqQ-unsplash_1747128644500.jpg"
        ],
        picchelinStatus: true,
        likeStatus: false,
        address: "서울시 스쿱구 원선20길 96, 730동",
        parkingInfo: "매장 건물 지하주차장",
        time: "매주 월~토 10:00 ~ 19:00",
        rating: "4.9",
        review: "(333)",
        distance: "2.2km"
    )
}

// MARK: StringLiterals
private enum StringLiterals: String {
    case 가게_상세정보 = "가게 상세정보"
    
    var text: String {
        return self.rawValue
    }
}

#Preview {
    HomeDetailView(
        repository: DIContainer.shared.storeDetailRepository,
        storeID: "storeID 예시"
    )
}

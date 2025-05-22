//
//  HomeView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/17/25.
//

import SwiftUI
import CoreLocation
import SCMLocation
import SCMLogger
import SCMScoopInfo

struct HomeView: View {
    
    @StateObject private var foodCategoryRepository: AnyFoodCategoryDisplayable
    @StateObject private var router = SCMRouter<HomePath>.shared
    @StateObject private var locationManager = DIContainer.shared.locationManager
    
    @State private var searchKeyword: String = ""
    @State private var populerStores: [RealtimePopularScoopEntity] = []
    
    @State private var aroundScoopFilter: AroundFilterType = .거리순
    @State private var isPicchelined: Bool = true
    @State private var isMyPicked: Bool = false
    @State private var aroundStores: [AroundStoreInfoEntity] = []
    
    init(repository: AnyFoodCategoryDisplayable) {
        self._foodCategoryRepository = StateObject(wrappedValue: repository)
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack {
                Color.scmBrightSprout
                    .ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        searchField
                        popularKeywords
                        categoryButtons
                        realtimePopularScoop(populerStores)
                        adBanners()
                        aroundScoop()
                    }
                }
            }
            .task {
                await locationManager.checkDeviceCondition()
                
                if self.populerStores.isEmpty || self.aroundStores.isEmpty {
                    let popularStores = await foodCategoryRepository.getPopularStoresInfo()
                    self.populerStores = popularStores
                    
                    let aroundStores = await foodCategoryRepository.getAroundStoreInfo(.픽슐랭, .거리순)
                    self.aroundStores = aroundStores
                }
            }
            .showAlert(
                isPresented: $locationManager.showAlert,
                title: "안내",
                message: locationManager.alertMessage, action: {
                    locationManager.openSettings()
                })
            .toolbarItem (leading: {
                addressButton
            })
            .navigationDestination(for: HomePath.self) { router in
                switch router {
                case .detail: HomeDetailView()
                }
            }
        }
    }
    
    private var addressButton: some View {
        HStack(alignment: .center, spacing: 8) {
            Image(.location)
                .basicImage(width: 24, color: .scmGray90)
            
            Text("\(locationManager.currentAddress)")
                .basicText(.PTTitle3, .scmGray90)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.5)
            
            Image(.detail)
                .basicImage(width: 24, color: .scmGray90)
        }
        .asButton {
            Log.debug("addressButton tapped")
        }
    }
    
    private var searchField: some View {
        HomeSearchFieldCell(
            placeholder: StringLiterals.placeholder.text,
            keyword: $searchKeyword
        )
        .defaultHorizontalPadding()
        .padding(.top, 8)
    }
    
    private var popularKeywords: some View {
        PopularKeywordCell(foodCategoryRepository: foodCategoryRepository)
        .padding(.vertical, 12)
        .defaultHorizontalPadding()
    }
    
    private var categoryButtons: some View {
        HomeCategoryCell(repository: DIContainer.shared.foodCategoryRepository)
        .defaultHorizontalPadding()
        .padding(.vertical, 20)
        .background(.scmGray15)
    }
    
    private func realtimePopularScoop(_ scoops: [RealtimePopularScoopEntity]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(StringLiterals.realtime_popular_scoop.text)
                .basicText(.PTTitle4, .scmGray90)
                .defaultHorizontalPadding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(scoops, id: \.storeID) { scoop in
                        RealtimePopularScoopCell(
                            imageHelper: DIContainer.shared.imageHelper,
                            store: scoop,
                            likeButtonOpacity: 1
                        ) {
                            Log.debug("좋아요 버튼 클릭 - 나중에 서버연결 해야함")
                        }
                    }
                }
                .defaultHorizontalPadding()
            }
            
            aiAlgorithm
                .defaultHorizontalPadding()
                .padding(.bottom, 14)
        }
        .background(.scmGray15)
    }
    
    private var aiAlgorithm: some View {
        HStack(alignment: .center, spacing: 2) {
            Image(.default)
                .basicImage(width: 16, color: .scmGray45)
            Text(StringLiterals.aiAlgoritym.text)
                .basicText(.PTCaption2, .scmGray45)
        }
    }
    
    private func adBanners() -> some View {
        AdBannerCell(imageHelper: DIContainer.shared.imageHelper)
    }
    
    private func aroundScoop() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            aroundScoopTitleAndFilter
            pickButton
            aroundScoopsCell
        }
        .defaultHorizontalPadding()
        .padding(.vertical, 18)
        .background(.scmGray15)
    }
    
    private var aroundScoopTitleAndFilter: some View {
        HStack(alignment: .center) {
            Text(StringLiterals.around_scoop.text)
                .basicText(.PTTitle4, .scmGray90)
            
            Spacer()
            
            HStack(alignment: .center, spacing: 4) {
                Text(aroundScoopFilter.text)
                    .basicText(.PTCaption1, .scmBlackSprout)
                Image(.list)
                    .basicImage(width: 16, color: .scmBlackSprout)
            }
            .asButton {
                // 내 근처스쿱 필터링 버튼
                switch aroundScoopFilter {
                case .거리순: return aroundScoopFilter = .별점순
                case .별점순: return aroundScoopFilter = .주문_많은순
                case .주문_많은순: return aroundScoopFilter = .즐겨찾기순
                case .즐겨찾기순: return aroundScoopFilter = .거리순
                @unknown default: return aroundScoopFilter = .거리순
                }
            }
        }
    }
    
    private var pickButton: some View {
        HStack(alignment: .center, spacing: 12) {
            AroundPickTypeButtonCell(isPicked: $isPicchelined, title: AroundType.픽슐랭.text) {
                setAroundPickStatus(&isPicchelined, &isMyPicked)
            }
            
            AroundPickTypeButtonCell(isPicked: $isMyPicked, title: AroundType.마이스쿱.text) {
                setAroundPickStatus(&isMyPicked, &isPicchelined)
            }
        }
        .padding(.top, 16)
    }
    
    private var aroundScoopsCell: some View {
        VStack(alignment: .leading, spacing: 5) {
            ForEach(aroundStores.indices, id: \.self) { index in
                AroundScoopCell(
                    imageHelper: DIContainer.shared.imageHelper,
                    store: aroundStores[index],
                    needDivider: index != (aroundStores.count - 1)
                ) {
                    Log.debug("하트버튼 클릭")
                }
            }
        }
        .padding(.top, 16)
    }
}

extension HomeView {
    private func setAroundPickStatus(_ main: inout Bool, _ sub: inout Bool) {
        main = (main == true) ? false : true
        sub = !main
    }
}

private enum StringLiterals: String {
    case placeholder = "검색어를 입력해주세요."
    case realtime_popular_scoop = "실시간 인기 스쿱"
    case aiAlgoritym = "스쿱미 AI 알고리즘 기반으로 추천된 맛집입니다."
    case around_scoop = "내 근처 스쿱"
    
    var text: String {
        return self.rawValue
    }
}

#Preview {
    HomeView(repository: DIContainer.shared.foodCategoryRepository)
}

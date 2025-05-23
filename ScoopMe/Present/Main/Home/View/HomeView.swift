//
//  HomeView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/17/25.
//

import SwiftUI
import CoreLocation
import SCMLocation
import SCMLogin
import SCMLogger
import SCMNetwork
import SCMScoopInfo

struct HomeView: View {
    
    @StateObject private var foodCategoryRepository: AnyFoodCategoryDisplayable
    @StateObject private var switcher = SCMSwitcher.shared
    @StateObject private var router = SCMRouter<HomePath>.shared
    @StateObject private var locationManager: LocationManager
    @StateObject private var loginTokenManager: LoginTokenManager
    
    @State private var searchKeyword: String = ""
    @State private var populerStores: [RealtimePopularScoopEntity] = []
    
    @State private var aroundScoopFilter: AroundFilterType = .distance
    @State private var isPicchelined: Bool = true
    @State private var isMyPicked: Bool = false
    @State private var aroundStores: [AroundStoreInfoEntity] = []
    
    @State private var showAlert: Bool = false
    
    init(
        repository: AnyFoodCategoryDisplayable,
        locationManager: LocationManager,
        loginTokenManager: LoginTokenManager
    ) {
        self._foodCategoryRepository = StateObject(wrappedValue: repository)
        self._locationManager = StateObject(wrappedValue: locationManager)
        self._loginTokenManager = StateObject(wrappedValue: loginTokenManager)
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
                        realtimePopularScoop()
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
                    
                    let aroundStores = await foodCategoryRepository.getAroundStoreInfo(.픽슐랭, .distance)
                    self.aroundStores = aroundStores
                }
            }
            .showAlert(
                isPresented: $locationManager.showAlert,
                title: "안내",
                message: locationManager.alertMessage, action: {
                    locationManager.openSettings()
                })
            .showAlert(
                isPresented: $showAlert,
                title: loginTokenManager.alertTitle,
                message: loginTokenManager.alertMessage,
                action: {
                    switcher.switchTo(.login)
                }
            )
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
    
    private func realtimePopularScoop() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(StringLiterals.realtime_popular_scoop.text)
                .basicText(.PTTitle4, .scmGray90)
                .defaultHorizontalPadding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(populerStores.indices, id: \.self) { index in
                        RealtimePopularScoopCell(
                            imageHelper: DIContainer.shared.imageHelper,
                            store: populerStores[index],
                            likeButtonOpacity: 1
                        ) {
                            Log.debug("좋아요 버튼 클릭")
                            Task {
                                await postLikeStatus(index)
                            }
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
                case .distance: return aroundScoopFilter = .reviews
                case .reviews: return aroundScoopFilter = .orders
                case .orders: return aroundScoopFilter = .favorites
                case .favorites: return aroundScoopFilter = .distance
                @unknown default: return aroundScoopFilter = .distance
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

// MARK: action
extension HomeView {
    private func setAroundPickStatus(_ main: inout Bool, _ sub: inout Bool) {
        main = (main == true) ? false : true
        sub = !main
    }
    
    private func postLikeStatus(_ index: Int) async {
        do {
            try await foodCategoryRepository.postStoreLikeStatus(store: populerStores[index].storeID, like: !populerStores[index].likeStatus)
            
            populerStores[index].likeStatus.toggle()
        } catch {
            await checkTokenValidation(error)
        }
    }
    
    private func checkTokenValidation(_ error: Error) async {
        if let scmError = error as? SCMError {
            switch scmError {
            case .serverError(let statusCode, _):
                switch statusCode {
                case 419: // access 만료 -> refresh 통신 진행
                    Log.debug("✅ accessToken만료")
                    await checkRefreshToken()
                case 401, 418: // refresh 토큰 오류 및 만료 -> 로그인 화면으로 보내기
                    loginTokenManager.alertTitle = "안내"
                    loginTokenManager.alertMessage = "세션이 만료되었습니다. 다시 로그인해주세요."
                    showAlert = true
                default: break
                }
            default: break
            }
        }
    }
    
    private func checkRefreshToken() async {
        do {
            try await loginTokenManager.requestRefreshToken()
        } catch {
            loginTokenManager.alertTitle = "안내"
            loginTokenManager.alertMessage = "세션이 만료되었습니다. 다시 로그인해주세요."
            showAlert = true
        }
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
    HomeView(
        repository: DIContainer.shared.foodCategoryRepository,
        locationManager: DIContainer.shared.locationManager,
        loginTokenManager: DIContainer.shared.loginTokenManager
    )
}

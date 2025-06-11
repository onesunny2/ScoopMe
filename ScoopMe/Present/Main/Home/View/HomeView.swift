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
    
    @StateObject private var repository: AnyFoodCategoryDisplayable
    @StateObject private var switcher = SCMSwitcher.shared
    @StateObject private var router = SCMRouter<HomePath>.shared
    @StateObject private var locationManager: LocationManager
    @StateObject private var loginTokenManager: LoginTokenManager
    
    @State private var searchKeyword: String = ""
    @State private var popularStores: [RealtimePopularScoopEntity] = []
    
    @State private var isPicchelined: Bool = true
    @State private var isMyPicked: Bool = false
    @State private var aroundStores: [AroundStoreInfoEntity] = []
    
    @State private var showAlert: Bool = false
    
    private var currentCheckbox: AroundType {
        return (isPicchelined == true && isMyPicked == false) ? .픽슐랭 : .마이스쿱
    }
    
    init(
        repository: AnyFoodCategoryDisplayable,
        locationManager: LocationManager,
        loginTokenManager: LoginTokenManager
    ) {
        self._repository = StateObject(wrappedValue: repository)
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
                        adBanners
                        aroundScoop()
                    }
                }
            }
            .task {
                await locationManager.checkDeviceCondition()
                
                if self.popularStores.isEmpty || self.aroundStores.isEmpty {
                    await getPopularStoreInfo()
                    await getAroundStoreFirstInfo(currentCheckbox)
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
            .onChange(of: repository.selectedCategory) { newCategory in
                Task {
                    await getPopularStoreInfo()
                    await getAroundStoreFirstInfo(currentCheckbox)
                }
            }
            .onChange(of: currentCheckbox) { newValue in
                Task {
                    Log.debug("✅ \(newValue) 선택")
                    await getAroundStoreFirstInfo(newValue)
                }
            }
            .onChange(of: repository.selectedFiltering) { newValue in
                Task {
                    Log.debug("✅ \(newValue) 선택")
                    await getAroundStoreFirstInfo(currentCheckbox)
                }
            }
            .toolbarItem (leading: {
                addressButton
            })
            .navigationDestination(for: HomePath.self) { router in
                switch router {
                case let .detail(id): HomeDetailView(storeDetailrepository: DIContainer.shared.storeDetailRepository, storeID: id)
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
        SearchTextFieldCell(
            placeholder: StringLiterals.placeholder.text,
            keyword: $searchKeyword
        )
        .defaultHorizontalPadding()
        .padding(.top, 8)
    }
    
    private var popularKeywords: some View {
        PopularKeywordCell(
            foodCategoryRepository: repository,
            loginTokenManager: loginTokenManager,
            showAlert: $showAlert
        )
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
                realtimeScrollCell
            }
            
            aiAlgorithm
                .defaultHorizontalPadding()
                .padding(.bottom, 14)
        }
        .background(.scmGray15)
    }
    
    private var realtimeScrollCell: some View {
        HStack {
            ForEach(popularStores.indices, id: \.self) { index in
                RealtimePopularScoopCell(
                    imageHelper: DIContainer.shared.imageHelper,
                    store: popularStores[index],
                    likeButtonOpacity: 1
                ) {
                    Log.debug("좋아요 버튼 클릭")
                    Task {
                        await postLikeStatus(
                            index: index,
                            id: popularStores[index].storeID,
                            status: !popularStores[index].likeStatus
                        ) {
                            popularStores[index].likeStatus.toggle()
                        }
                    }
                }
                .asButton {
                    Log.debug("⏭️ 실시간 인기스쿱 Cell 클릭")
                    router.send(.push(.detail(id: popularStores[index].storeID)))
                }
            }
        }
        .defaultHorizontalPadding()
    }
    
    private var aiAlgorithm: some View {
        HStack(alignment: .center, spacing: 2) {
            Image(.default)
                .basicImage(width: 16, color: .scmGray45)
            Text(StringLiterals.aiAlgoritym.text)
                .basicText(.PTCaption2, .scmGray45)
        }
    }
    
    private var adBanners: some View {
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
                Text(repository.selectedFiltering.text)
                    .basicText(.PTCaption1, .scmBlackSprout)
                Image(.list)
                    .basicImage(width: 16, color: .scmBlackSprout)
            }
            .asButton {
                // 내 근처스쿱 필터링 버튼
                switch repository.selectedFiltering {
                case .distance:
                    repository.selectedFiltering = .reviews
                case .reviews:
                    repository.selectedFiltering = .orders
                case .orders:
                    repository.selectedFiltering = .distance
                @unknown default:
                    repository.selectedFiltering = .distance
                }
            }
        }
    }
    
    private var pickButton: some View {
        HStack(alignment: .center, spacing: 12) {
            AroundPickTypeButtonCell(isPicked: $isPicchelined, title: AroundType.픽슐랭.text) {
                Log.debug("픽슐랭 버튼 클릭")
                setAroundPickStatus(&isPicchelined, &isMyPicked)
            }
            
            AroundPickTypeButtonCell(isPicked: $isMyPicked, title: AroundType.마이스쿱.text) {
                Log.debug("마이픽 버튼 클릭")
                setAroundPickStatus(&isMyPicked, &isPicchelined)
            }
        }
        .padding(.top, 16)
    }
    
    private var aroundScoopsCell: some View {
        LazyVStack {
            LazyVStack(alignment: .leading, spacing: 5) {
                ForEach(aroundStores.indices, id: \.self) { index in
                    AroundScoopCell(
                        imageHelper: DIContainer.shared.imageHelper,
                        store: aroundStores[index],
                        needDivider: index != (aroundStores.count - 1)
                    ) {
                        Task {
                            await postLikeStatus(
                                index: index,
                                id: aroundStores[index].storeID,
                                status: !aroundStores[index].likeStatus
                            ) {
                                Log.debug("하트버튼 클릭")
                                aroundStores[index].likeStatus.toggle()
                            }
                        }
                    }
                    .onAppear {
                        if aroundStores[index].storeID == repository.lastStoreID {
                            // 페이지네이션 추가
                            repository.isLoading = true
                            Task {
                                await getAroundStoreNextInfo(currentCheckbox)
                            }
                            repository.isLoading = false
                        }
                    }
                    .asButton {
                        Log.debug("⏭️ 내 근처스쿱 Cell 클릭")
                        router.send(.push(.detail(id: aroundStores[index].storeID)))
                    }
                }
            }
            
            // 데이터 로드 전용 indicatorView
            if repository.isLoading {
                ProgressView()
                    .padding(5)
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
    
    // 리프레시 토큰 갱신 로직 포함
    private func postLikeStatus(index: Int, id: String, status: Bool, action: (() -> ())?) async {
        do {
            try await repository.postStoreLikeStatus(store: id, like: status)
            
            action?()  // 상태값 toggle 위함
        } catch {
            await checkTokenValidation(error) {
                try await repository.postStoreLikeStatus(store: id, like: status)
                
                action?()
            }
        }
    }
    
    // 리프레시 토큰 갱신 로직 포함
    private func getPopularStoreInfo() async {
        do {
            let popularStores = try await repository.getPopularStoresInfo()
            self.popularStores = popularStores
        } catch {
            await checkTokenValidation(error) {
                let popularStores = try await repository.getPopularStoresInfo()
                self.popularStores = popularStores
            }
        }
    }
    
    // 내 근처스쿱 - 가장 첫 데이터로 갈아끼울 때
    private func getAroundStoreFirstInfo(_ round: AroundType) async {
        do {
            repository.lastStoreID = ""  // query id 초기화
            
            let aroundStores = try await repository.getAroundStoreInfo(round)
            self.aroundStores = aroundStores
        } catch {
            await checkTokenValidation(error) {
                repository.lastStoreID = ""
                
                let aroundStores = try await repository.getAroundStoreInfo(round)
                self.aroundStores = aroundStores
            }
        }
    }
    
    // 내 근처스쿱 - 페이지네이션을 위한 append
    private func getAroundStoreNextInfo(_ round: AroundType) async {
        do {
            let aroundStores = try await repository.getAroundStoreInfo(round)
            self.aroundStores.append(contentsOf: aroundStores)
        } catch {
            await checkTokenValidation(error) {
                let aroundStores = try await repository.getAroundStoreInfo(round)
                self.aroundStores.append(contentsOf: aroundStores)
            }
        }
    }
    
    private func checkTokenValidation(_ error: Error, complete: @escaping () async throws -> ()) async {
        if let scmError = error as? SCMError {
            switch scmError {
            case .serverError(let statusCode, _):
                switch statusCode {
                case 419: // access 만료 -> refresh 통신 진행
                    Log.debug("✅ accessToken만료")
                    await checkRefreshToken(complete: complete)
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
    
    private func checkRefreshToken(complete: @escaping () async throws -> ()) async {
        do {
            try await loginTokenManager.requestRefreshToken()
            try await complete()
        } catch {
            loginTokenManager.alertTitle = "안내"
            loginTokenManager.alertMessage = "세션이 만료되었습니다. 다시 로그인해주세요."
            showAlert = true
        }
    }
}

// MARK: StringLiterals
private enum StringLiterals: String {
    case placeholder = "검색어를 입력해주세요."
    case realtime_popular_scoop = "실시간 인기 스쿱"
    case aiAlgoritym = "스쿱미 AI 알고리즘 기반으로 추천된 맛집입니다."
    case around_scoop = "내 근처 스쿱"
    case aroundScoop_ID = "내 근처 스쿱 SectionID"
    
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

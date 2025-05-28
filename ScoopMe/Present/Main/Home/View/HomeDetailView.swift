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
    @Namespace private var textfieldID
    
    @StateObject private var repository: AnyStoreDetailDisplayable
    
    let storeID: String
    
    // 상단 가게 정보
    @State private var storeInfos: StoreDetailInfoEntity = empty
    @State private var isShowDetail: Bool = false
    
    // 메뉴 정보
    @State private var searchKeyword: String = ""
    @State private var showTextfield: Bool = false
    @State private var menuInfos: [StoreDetailMenuEntity] = []
    
    @State private var menuSections: [String] = []
    @State private var currentVisibleSection: String = ""
    @State private var isButtonTriggered: Bool = false  // 스크롤 위치감지 막기위한 트리거
    
    // 메뉴 가격
    @State private var selectedCount: Int = 0
    @State private var selectedPrice: Int = 0
    
    init(repository: AnyStoreDetailDisplayable, storeID: String) {
        self._repository = StateObject(wrappedValue: repository)
        self.storeID = storeID
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                            imageTabview
                                .offset(y: -geometry.safeAreaInsets.top)
                                .padding(.bottom, -geometry.safeAreaInsets.top)
                            storeManageInfo
                            divider
                            menuSections(parentGeometry: geometry, scrollProxy: proxy)
                        }
                    }
                }
                needToPayCell
            }
        }
        .task {
            await getStoreDetailInfo()
            await getMenuInfo()
        }
        .backButton(.scmGray0)
        .toolbarItem (trailing: {
            Image(storeInfos.likeStatus ? .likeFill : .likeEmpty)
                .basicImage(width: 32, color: .scmGray0)
        })
        .toolbar(.hidden, for: .tabBar)
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
            
            if storeInfos.picchelinStatus { PickBadgeCell() }
            
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
    
    // 상세정보와 메뉴 사이의 구분선
    private var divider: some View {
        Rectangle()
            .fill(.scmBrightSprout)
            .frame(maxWidth: .infinity, maxHeight: 1)
    }
    
    @ViewBuilder
    private func menuSections(parentGeometry: GeometryProxy, scrollProxy: ScrollViewProxy) -> some View {
        let safeAreaTop = parentGeometry.safeAreaInsets.top
        let headerHeight: CGFloat = 60
        let targetY = safeAreaTop + headerHeight + 200

        Section(header: menuHeaderSection(scrollProxy: scrollProxy)) {
            ForEach(Array(menuSections.enumerated()), id: \.element) { index, sectionTitle in
                sectionContentView(sectionTitle: sectionTitle, index: index, targetY: targetY)
            }
        }
    }
    
    @ViewBuilder
    private func sectionContentView(sectionTitle: String, index: Int, targetY: CGFloat) -> some View {
        VStack(spacing: 0) {
            sectionTitleView(sectionTitle, targetY: targetY)
                .defaultHorizontalPadding()
                .padding(.bottom, 8)
            
            sectionContents(section: sectionTitle)
                .defaultHorizontalPadding()
            
            if index < menuSections.count - 1 {
                Rectangle()
                    .fill(.scmGray15)
                    .frame(maxWidth: .infinity, minHeight: 12)
            }
        }
    }
    
    private func menuHeaderSection(scrollProxy: ScrollViewProxy) -> some View {
        HStack(alignment: .center, spacing: 4) {
            if !showTextfield {
                Image(.search)
                    .basicImage(width: 16, color: .scmGray90)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 50)
                            .fill(.scmGray30)
                            .matchedGeometryEffect(id: "search", in: textfieldID)
                    )
                    .asButton {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showTextfield.toggle()
                        }
                    }
            } else {
                DetailSearchFieldCell(
                    text: $searchKeyword,
                    showTextfield: $showTextfield,
                    placeholder: "",
                    textfieldID: textfieldID
                )
                .transition(.opacity)
            }
            
            Spacer(minLength: 2)
            
            if !showTextfield {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 4) {
                        ForEach(menuSections, id: \.self) { menu in
                            headerMenuButton(menu, scrollProxy: scrollProxy)
                        }
                    }
                }
                .transition(.opacity)
            }
        }
        .padding(.vertical, 12)
        .defaultHorizontalPadding()
        .background(.scmGray0)
    }
    
    // section Title
    private func sectionTitleView(_ title: String, targetY: CGFloat) -> some View {
        HStack {
            Text(title)
                .basicText(.PTTitle3, .scmGray90)
            Spacer()
        }
        .id(title)
        .background(
            // 섹션 위치 추적용 GeometryReader
            GeometryReader { sectionGeometry in
                let globalFrame = sectionGeometry.frame(in: .global)
                
                Color.clear
                    .onAppear {
                        checkVisibleSection(
                            sectionTitle: title,
                            globalFrame: globalFrame,
                            targetY: targetY
                        )
                    }
                    .onChange(of: globalFrame.minY) { _ in
                        checkVisibleSection(
                            sectionTitle: title,
                            globalFrame: globalFrame,
                            targetY: targetY
                        )
                    }
            }
        )
        .padding(.top, 18)
    }
    
    // 헤더 메뉴 버튼 (현재 보이는 섹션에 따라 색상 변경)
    private func headerMenuButton(_ menu: String, scrollProxy: ScrollViewProxy) -> some View {
        let isActive = currentVisibleSection == menu
        
        return Text(menu)
            .basicText(.PTBody2, isActive ? .scmBlackSprout : .scmGray60)
            .strokeRoundBackground(
                .scmGray0,
                isActive ? .scmBlackSprout : .scmGray60,
                isActive ? 2 : 1, 50
            )
            .padding(.horizontal, 3)
            .padding(.vertical, 1)
            .animation(.easeInOut(duration: 0.2), value: isActive)
            .asButton {
                // 해당 섹션으로 스크롤
                withAnimation(.easeInOut) {
                    isButtonTriggered = true
                    currentVisibleSection = menu
                    scrollProxy.scrollTo(menu, anchor: .center)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isButtonTriggered = false
                }
            }
    }
    

    private func sectionContents(section title: String) -> some View {
        let sectionMenus = menuInfos.filter { $0.category == title }
        
        return ForEach(Array(sectionMenus.enumerated()), id: \.element.menuID) { index, menu in
            VStack(spacing: 0) {
                DetailMenuCell(selectedCount: $selectedCount, selectedPrice: $selectedPrice, menu: menu)
                
                if index < sectionMenus.count - 1 {
                    Rectangle()
                        .fill(.scmGray30)
                        .frame(maxWidth: .infinity, maxHeight: 1)
                        .padding(.vertical, 8)
                }
            }
        }
    }
    
    // 총 결제금액 view
    @ViewBuilder
    private var needToPayCell: some View {
        if selectedCount > 0 {
            BottomPriceCell(count: selectedCount, price: selectedPrice)
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .move(edge: .bottom).combined(with: .opacity)
                ))
                .ignoresSafeArea(.container, edges: .bottom)
                .onTapGesture {
                    Log.debug("⏭️ 결제하기 버튼 클릭")
                }
        }
    }
}

// MARK: Action
extension HomeDetailView {
    
    private func checkVisibleSection(sectionTitle: String, globalFrame: CGRect, targetY: CGFloat) {
        let sectionTop = globalFrame.minY
        let sectionBottom = globalFrame.maxY
        
        // 감지 영역: 헤더 아래부터 화면 상단 1/3 지점까지
        let detectionStart = targetY - 100
        let detectionEnd = targetY + 400
        
        // 버튼 클릭으로 스크롤 중이면 감지하지 않음
        guard !isButtonTriggered else { return }
        
        // 섹션이 감지 영역에 들어오면 활성화
        if sectionTop <= detectionEnd && sectionBottom >= detectionStart {
            if currentVisibleSection != sectionTitle {
                withAnimation(.easeInOut(duration: 0.2)) {
                    currentVisibleSection = sectionTitle
                }
            }
        }
        // 섹션이 감지 영역을 완전히 벗어나면 체크
        else if currentVisibleSection == sectionTitle && sectionBottom < detectionStart {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                if currentVisibleSection == sectionTitle && !isButtonTriggered {
                    // 필요에 따라 빈 값으로 설정하거나 현재 값 유지
                }
            }
        }
    }
    
    
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
    
    private func getMenuInfo() async {
        do {
            let info = try await repository.getStoreDetailMenu(id: storeID)
            
            self.menuInfos = info.menu
            self.menuSections = info.section
            
            // 첫 번째 섹션 설정
            if let firstSection = info.section.first {
                self.currentVisibleSection = firstSection
            }
            
            Log.debug("✅ menuSections 업데이트: \(info.section)")
        } catch {
            await repository.checkTokenValidation(error) {
                let info = try await repository.getStoreDetailMenu(id: storeID)
                
                self.menuInfos = info.menu
                self.menuSections = info.section
                
                // 첫 번째 섹션 설정
                if let firstSection = info.section.first {
                    self.currentVisibleSection = firstSection
                }
                
                Log.debug("✅ menuSections 업데이트: \(info.section)")
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
    case placeholder
    
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

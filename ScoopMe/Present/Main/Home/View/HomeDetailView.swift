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
    @Namespace private var namespaceId
    
    @StateObject private var repository: AnyStoreDetailDisplayable
    
    let storeID: String
    
    @State private var storeInfos: StoreDetailInfoEntity = empty
    @State private var isShowDetail: Bool = false
    
    @State private var searchKeyword: String = ""
    @State private var showTextfield: Bool = false
    @State private var menuInfos: [StoreDetailMenuEntity] = []
    
    @State private var currentVisibleSection: String = ""
    
    init(repository: AnyStoreDetailDisplayable, storeID: String) {
        self._repository = StateObject(wrappedValue: repository)
        self.storeID = storeID
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    imageTabview
                        .offset(y: -geometry.safeAreaInsets.top)
                        .padding(.bottom, -geometry.safeAreaInsets.top)
                    storeManageInfo
                    divider
                    menuSections(parentGeometry: geometry)
                }
            }
        }
        .task {
            await getStoreDetailInfo()
            await getMenuInfo()
        }
        .onAppear {
            self.currentVisibleSection = repository.menuSections.first ?? ""
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
    
    // 상세정보와 메뉴 사이의 구분선
    private var divider: some View {
        Rectangle()
            .fill(.scmBrightSprout)
            .frame(maxWidth: .infinity, maxHeight: 1)
    }
    
    // 메뉴 섹션들
    private func menuSections(parentGeometry: GeometryProxy) -> some View {
        let safeAreaTop = parentGeometry.safeAreaInsets.top
        let headerHeight: CGFloat = 60
        let targetY = safeAreaTop + headerHeight + 200
        
        return Section(header: menuHeaderSection) {
            ForEach(repository.menuSections, id: \.self) { sectionTitle in
                VStack(spacing: 0) {
                    // 각 섹션의 타이틀 뷰
                    sectionTitleView(sectionTitle, targetY: targetY)
                        .defaultHorizontalPadding()
                    
                    // 각 섹션의 메뉴 아이템들
                    sectionContents(section: sectionTitle)
                        .defaultHorizontalPadding()
                    
                    Rectangle()
                        .fill(.scmGray15)
                        .frame(maxWidth: .infinity, minHeight: 12)
                }
            }
        }
    }
    
    private var menuHeaderSection: some View {
        HStack(alignment: .center, spacing: 4) {
            if !showTextfield {
                Image(.search)
                    .basicImage(width: 16, color: .scmGray90)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 50)
                            .fill(.scmGray30)
                            .matchedGeometryEffect(id: "search", in: namespaceId)
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
                    namespaceId: namespaceId
                )
                .transition(.opacity)
            }
            
            Spacer(minLength: 2)
            
            if !showTextfield {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 4) {
                        ForEach(repository.menuSections, id: \.self) { menu in
                            headerMenuButton(menu)
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
    private func headerMenuButton(_ menu: String) -> some View {
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
                // ScrollViewReader의 scrollTo 메서드 사용 가능
            }
    }
    

    private func sectionContents(section title: String) -> some View {
        let sectionMenus = menuInfos.filter { $0.category == title }
        
        return ForEach(Array(sectionMenus.enumerated()), id: \.element.menuID) { index, menu in
            VStack(spacing: 0) {
                DetailMenuCell(menu: menu)
                
                if index < sectionMenus.count - 1 {
                    Rectangle()
                        .fill(.scmGray30)
                        .frame(maxWidth: .infinity, maxHeight: 1)
                        .padding(.vertical, 8)
                }
            }
        }
    }
}

// MARK: Action
extension HomeDetailView {
    
    // 글로벌 좌표계를 사용한 섹션 감지
       private func checkVisibleSection(sectionTitle: String, globalFrame: CGRect, targetY: CGFloat) {
           let sectionTop = globalFrame.minY
           let sectionBottom = globalFrame.maxY
           
           // 감지 영역: 헤더 아래부터 화면 상단 1/3 지점까지
           let detectionStart = targetY - 100  // 헤더보다 조금 위부터
           let detectionEnd = targetY + 400   // 헤더 아래 넓은 영역까지
           
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
               // 다른 섹션이 활성화되지 않은 경우 잠시 대기
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                   if currentVisibleSection == sectionTitle {
                       // 필요에 따라 빈 값으로 설정하거나 현재 값 유지
                       // currentVisibleSection = ""
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
            self.menuInfos = info
        } catch {
            await repository.checkTokenValidation(error) {
                let info = try await repository.getStoreDetailMenu(id: storeID)
                self.menuInfos = info
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

//
//  HomeView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/17/25.
//

import SwiftUI
import SCMLocation
import SCMLogger
import CoreLocation

struct HomeView: View {
    
    @StateObject private var router = SCMRouter<HomePath>.shared
    @StateObject private var locationManager = DIContainer.shared.locationManager
    
    @State private var searchKeyword: String = ""
    @State private var keywordIndex: Int = 0
    @State private var timer: Timer? = nil
    
    @State private var selectedCategory: Int = 0
    @State private var showMoreCategory: Bool = false
    
    private let categorySpacing = (UIScreen.main.bounds.size.width - 320) / 4
    
    private let testPopulars: [String] = [
        "새싹 베이커리",
        "달콤 카페",
        "새싹 치킨 도봉점"
    ]
    
    @State private var testCategoryText: [String] = [
        "커피", "패스트푸드", "디저트", "베이커리", "더보기", "한식", "일식", "분식", "샐러드", "샌드위치"
    ]
    @State private var testCategoryImage: [Image] = [
        Image(.coffee), Image(.fastFood), Image(.dessert), Image(.bakery), Image(.more),
        Image(.hansik), Image(.ilsik), Image(.bunsik), Image(.salad), Image(.sandwich)
    ]
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack {
                Color.scmBrightSprout
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading) {
                        searchField
                        popularKeywords
                        categoryButtons
                    }
                }
            }
            .task {
                await locationManager.checkDeviceCondition()
            }
            .onAppear {
                startTimer()
            }
            .onDisappear {
                stopTimer()
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
        HStack(alignment: .center, spacing: 8) {
            HStack(alignment: .center, spacing: 2) {
                Image(.default)
                    .basicImage(width: 12, color: .scmDeepSprout)
                Text(StringLiterals.popularKeywordTitle.text)
                    .basicText(.PTCaption1, .scmDeepSprout)
            }
            
            Text(currentPopularKeyword())
                .basicText(.PTCaption1, .scmBlackSprout)
                .transition(.push(from: .bottom).combined(with: .opacity))
                .id("keyword_\(keywordIndex)")
        }
        .padding(.vertical, 8)
        .defaultHorizontalPadding()
    }
    
    private var categoryButtons: some View {
        VStack(alignment: .center, spacing: 8) {
            HStack(spacing: categorySpacing) {
                ForEach(0..<5, id: \.self) { index in
                    HomeCategoryButtonCell(
                        image: testCategoryImage[index],
                        title: testCategoryText[index],
                        isSelected: (index == selectedCategory && testCategoryText[selectedCategory] != "더보기") ? true : false
                    )
                    .asButton {
                        if index == 4 && testCategoryText[index] == "더보기" {
                            withAnimation(.easeInOut) {
                                showMoreCategory = true
                                testCategoryText.swapAt(4, 9)
                                testCategoryImage.swapAt(4, 9)
                                testCategoryText[9] = "접기"
                            }
                        } else {
                            selectedCategory = index
                        }
                        Log.debug("버튼 클릭")
                    }
                }
            }
            
            if showMoreCategory {
                HStack(spacing: categorySpacing) {
                    ForEach(5..<testCategoryText.count, id: \.self) { index in
                        HomeCategoryButtonCell(
                            image: testCategoryImage[index],
                            title: testCategoryText[index],
                            isSelected: (index == selectedCategory) ? true : false
                        )
                        .asButton {
                            if index == 9 && testCategoryText[index] == "접기" {
                                withAnimation(.easeInOut) {
                                    showMoreCategory = false
                                    testCategoryText.swapAt(4, 9)
                                    testCategoryImage.swapAt(4, 9)
                                    testCategoryText[4] = "더보기"
                                }
                            } else {
                                selectedCategory = index
                            }
                            Log.debug("버튼 클릭")
                        }
                    }
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .id("category_\(selectedCategory)")
            }
        }
        .defaultHorizontalPadding()
        .padding(.vertical, 20)
        .background(.scmGray15)
    }
}

extension HomeView {
    /// 인기검색어 세팅
    private func updateKeywordIndex() async {
        await MainActor.run {
            withAnimation(.easeInOut(duration: 0.3)) {
                if keywordIndex < testPopulars.count - 1 {
                    keywordIndex += 1
                } else {
                    keywordIndex = 0
                }
            }
        }
    }
    
    private func currentPopularKeyword() -> String {
        return "\(keywordIndex + 1).  \(testPopulars[keywordIndex])"
    }
    
    /// 타이머
    private func startTimer() {
        stopTimer()
        
        timer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { _ in
            Task {
                await updateKeywordIndex()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

private enum StringLiterals: String {
    case placeholder = "검색어를 입력해주세요."
    case popularKeywordTitle = "인기검색어"
    
    var text: String {
        return self.rawValue
    }
}

#Preview {
    HomeView()
}

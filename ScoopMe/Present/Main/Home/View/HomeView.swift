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
    
    private let testRealtimes: [RealtimePopularScoopEntity] = Array(
        repeating: RealtimePopularScoopEntity(
            scoopID: 0,
            scoopImage: Image(.mangoTest),
            likeStatus: true,
            scoopName: "새싹 망빙 전문점",
            likeCount: "100개",
            distance: "0.5km",
            pickupCount: "111회"
        ),
        count: 10
    )
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack {
                Color.scmBrightSprout
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        searchField
                        popularKeywords
                        categoryButtons
                        realtimePopularScoop(testRealtimes)
                    }
                }
            }
            .task {
                await locationManager.checkDeviceCondition()
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
        PopularKeywordCell()
        .padding(.vertical, 12)
        .defaultHorizontalPadding()
    }
    
    private var categoryButtons: some View {
        HomeCategoryCell()
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
                    ForEach(scoops, id: \.scoopID) { scoop in
                        RealtimePopularScoopCell(scoop: scoop)
                    }
                }
                .defaultHorizontalPadding()
            }
            
            aiAlgorithm
                .defaultHorizontalPadding()
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
}

private enum StringLiterals: String {
    case placeholder = "검색어를 입력해주세요."
    case realtime_popular_scoop = "실시간 인기 스쿱"
    case aiAlgoritym = "스쿱미 AI 알고리즘 기반으로 추천된 맛집입니다."
    
    var text: String {
        return self.rawValue
    }
}

#Preview {
    HomeView()
}

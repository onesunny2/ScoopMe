//
//  MainTabView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/17/25.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Group {
                HomeView(
                    repository: DIContainer.shared.foodCategoryRepository,
                    locationManager: DIContainer.shared.locationManager,
                    loginTokenManager: DIContainer.shared.loginTokenManager
                )
                .tabImage(Image(.homeFill))
                .tag(0)
                
                OrderView()
                    .tabImage(Image(.orderFill))
                    .tag(1)
                
                ChatView()
                    .tabImage(
                        Image(.tabMessageFill)
                    )
                    .tag(2)
                
                CommunityView(
                    repository: DIContainer.shared.communityPostRepository
                )
                    .tabImage(Image(.communityFill))
                    .tag(3)
                
                ProfileView()
                    .tabImage(Image(.profileFill))
                    .tag(4)
            }
            .toolbarBackground(.scmGray0, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
        .tint(.scmBlackSprout)
    }
}

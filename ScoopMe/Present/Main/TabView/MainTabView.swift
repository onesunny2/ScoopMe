//
//  MainTabView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/17/25.
//

import SwiftUI
import SCMPayment

struct MainTabView: View {
    
    @EnvironmentObject private var tabFlowSwitcher: SCMSwitcher<TabFlow>
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
                
                OrderView(paymentRepository: DIContainer.shared.paymentRepository)
                    .tabImage(Image(.orderFill))
                    .tag(1)
                
                ChatRoomListView(
                    chatListRepository: DIContainer.shared.chatListRepository
                )
                    .tabImage(Image(.tabMessageFill))
                    .tag(2)
                
                CommunityView(
                    repository: DIContainer.shared.communityPostRepository,
                    chatListRepository: DIContainer.shared.chatListRepository
                )
                    .tabImage(Image(.communityFill))
                    .tag(3)
                
                ProfileView()
                    .tabImage(Image(.profileFill))
                    .tag(4)
            }
            .toolbarBackground(.scmGray0, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .onChange(of: selectedTab) { newValue in
                let flow = TabFlow.allCases[newValue]
                tabFlowSwitcher.switchTo(flow)
            }
            .onChange(of: tabFlowSwitcher.currentFlow) { newFlow in
                if let index = TabFlow.allCases.firstIndex(of: newFlow) {
                    selectedTab = index
                }
            }
        }
        .tint(.scmBlackSprout)
    }
}

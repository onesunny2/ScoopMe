//
//  MainTabView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/17/25.
//

import SwiftUI

struct MainTabView: View {
    
    @StateObject private var router = SCMRouter<TabFlow>.shared
    @State private var selectedTab: Int = 0
    
    var body: some View {
        NavigationStack(path: $router.path) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabImage(Image(.homeFill))
                    .tag(0)
                
                OrderView()
                    .tabImage(Image(.orderFill))
                    .tag(1)
                
                ChatView()
                    .tabImage(Image(.messageFill))
                    .tag(2)
                
                CommunityView()
                    .tabImage(Image(.communityFill))
                    .tag(3)
                
                ProfileView()
                    .tabImage(Image(.profileFill))
                    .tag(4)
            }
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(.scmGray0, for: .tabBar)
            .toolbarColorScheme(.none, for: .tabBar)
        }
    }
}

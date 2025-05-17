//
//  TabView.swift
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
            TabView {
                HomeView()
                    .tabImage(Image(.homeFill))
                
                OrderView()
                    .tabImage(Image(.orderFill))
                
                ChatView()
                    .tabImage(Image(.messageFill))
                
                CommunityView()
                    .tabImage(Image(.communityFill))
                
                ProfileView()
                    .tabImage(Image(.profileFill))
            }
            .toolbarBackgroundVisibility(.visible, for: .tabBar)
            .toolbarBackground(.scmGray0, for: .tabBar)
            .toolbarColorScheme(.none, for: .tabBar)
        }
    }
}

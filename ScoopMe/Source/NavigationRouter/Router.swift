//
//  Router.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/11/25.
//

import SwiftUI

final class Router: ObservableObject {
    
    // 앱 전체 네비게이션
    @Published var appPath = NavigationPath()
    
    // 각 최상위 화면별 네비게이션
    @Published var loginPath = NavigationPath()
    
    // 현재 선택된 탭
    @Published var selectedTab: Int = 0
    
    // 로그인 여부
    @Published var isLoggedIn: Bool = false
    
    // 선택된 탭으로 이동
    // 만약 각 탭으로 이동했을 때 기존의 화면을 root로 돌리고 싶으면 작업하기
    
    // 앱 전체 수준의 화면 전환 관리
    func pushToAppRoute(_ route: AppRoute) {
        appPath.append(route)
        
        // 탭 간의 이동일 경우 selectedTab 업데이트
        switch route {
        case .home(let tab): selectedTab = tab
        case .order(let tab): selectedTab = tab
        case .community(let tab): selectedTab = tab
        case .profile(let tab): selectedTab = tab
        case .chatting(let tab): selectedTab = tab
        default: break
        }
    }
}

// 로그인 완료, 로그아웃 관련
extension Router {
    
    func completeLogin() {
        isLoggedIn = true
        loginPath = NavigationPath()
        
        // 홈 탭화면으로 이동
        pushToAppRoute(.home(tab: 0))
    }
    
    func logout() {
        isLoggedIn = false
        
        // 모든 경로 초기화
        appPath = NavigationPath()
        loginPath = NavigationPath()
    }
}

// 로그인 화면 관련
extension Router {
    
    func pushLoginRoute(_ route: LoginRoute) {
        loginPath.append(route)
    }
    
    func popLoginRoute() {
        guard !loginPath.isEmpty else { return }
        loginPath.removeLast()
    }
    
    func popToLoginRoot() {
        loginPath = NavigationPath()
    }
}

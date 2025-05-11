//
//  AppRoute.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/11/25.
//

import Foundation

enum AppRoute: Hashable {
    case login
    case home(tab: Int)
    case order(tab: Int)
    case community(tab: Int)
    case profile(tab: Int)
    case chatting(tab: Int)
}

enum LoginRoute: Hashable {
    case emailLogin
    case signup
}
